import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:haushaltsbuch/utils/number_formatters/number_formatter.dart';

import '/components/cards/percentage_card.dart';
import '/components/deco/loading_indicator.dart';

import '/models/account.dart';
import '/models/percentage_stats.dart';
import '/models/enums/account_types.dart';
import '/models/enums/statistic_types.dart';
import '/models/enums/asset_allocation_statistic_types.dart';

class AssetAllocationStatisticTabView extends StatefulWidget {
  const AssetAllocationStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetAllocationStatisticTabView> createState() => _AssetAllocationStatisticTabViewState();
}

class _AssetAllocationStatisticTabViewState extends State<AssetAllocationStatisticTabView> {
  List<PercentageStats> _percentageStats = [];
  String _assetAllocationStatisticType = AssetAllocationStatisticType.individualAccounts.name;
  String _listStatisticType = StatisticType.assets.name;
  double _totalAmount = 0.0;

  Future<List<PercentageStats>> _loadAssetAllocationStatistic() async {
    _percentageStats = [];
    List<Account> _accountList = [];
    if (_listStatisticType == StatisticType.assets.name || _assetAllocationStatisticType == AssetAllocationStatisticType.capitalOrRiskFreeInvestments.name) {
      _accountList = await Account.loadAssetAccounts();
      _totalAmount = await Account.getAssetValue();
    } else {
      _accountList = await Account.loadLiabilityAccounts();
      _totalAmount = await Account.getLiabilityValue();
    }
    for (int i = 0; i < _accountList.length; i++) {
      if (_assetAllocationStatisticType == AssetAllocationStatisticType.individualAccounts.name && formatMoneyAmountToDouble(_accountList[i].bankBalance) != 0.0) {
        _percentageStats = PercentageStats.showSeparatePercentages(i, _accountList[i].bankBalance, _percentageStats, _accountList[i].name);
      } else if (_assetAllocationStatisticType == AssetAllocationStatisticType.individualAccountTypes.name && formatMoneyAmountToDouble(_accountList[i].bankBalance) != 0.0) {
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(
            i, _accountList[i].bankBalance, _percentageStats, AccountTypeExtension.getAccountTypePluralName(_accountList[i].accountType), false);
      } else if (_assetAllocationStatisticType == AssetAllocationStatisticType.capitalOrRiskFreeInvestments.name) {
        if (_accountList[i].accountType == AccountType.capitalInvestments.name) {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _accountList[i].bankBalance, _percentageStats, AccountType.capitalInvestments.pluralName, false);
        } else {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _accountList[i].bankBalance, _percentageStats, 'risikolose Anlagen', false);
        }
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalAmount);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  void _changeAssetAllocationStatisticType() {
    if (_assetAllocationStatisticType == AssetAllocationStatisticType.individualAccounts.name) {
      _assetAllocationStatisticType = AssetAllocationStatisticType.individualAccountTypes.name;
    } else if (_assetAllocationStatisticType == AssetAllocationStatisticType.individualAccountTypes.name) {
      _assetAllocationStatisticType = AssetAllocationStatisticType.capitalOrRiskFreeInvestments.name;
    } else if (_assetAllocationStatisticType == AssetAllocationStatisticType.capitalOrRiskFreeInvestments.name) {
      _assetAllocationStatisticType = AssetAllocationStatisticType.individualAccounts.name;
    }
    setState(() {});
  }

  void _changeListStatisticType() {
    if (_listStatisticType == StatisticType.assets.name) {
      _listStatisticType = StatisticType.debts.name;
    } else if (_listStatisticType == StatisticType.debts.name) {
      _listStatisticType = StatisticType.assets.name;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _loadAssetAllocationStatistic(),
        builder: (BuildContext context, AsyncSnapshot<List<PercentageStats>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingIndicator();
            case ConnectionState.done:
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 2.0,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 4.0,
                        centerSpaceRadius: 30.0,
                        sections: _showingSections(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () => _changeAssetAllocationStatisticType(),
                          child: Text(
                            _assetAllocationStatisticType,
                            style: const TextStyle(color: Colors.cyanAccent),
                          ),
                        ),
                        _assetAllocationStatisticType == AssetAllocationStatisticType.individualAccounts.name ||
                                _assetAllocationStatisticType == AssetAllocationStatisticType.individualAccountTypes.name
                            ? OutlinedButton(
                                onPressed: () => _changeListStatisticType(),
                                child: Text(
                                  _listStatisticType,
                                  style: const TextStyle(color: Colors.cyanAccent),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _percentageStats = await _loadAssetAllocationStatistic();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 235.0,
                      child: ListView.builder(
                        itemCount: _percentageStats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PercentageCard(percentageStats: _percentageStats[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            default:
              if (snapshot.hasError) {
                return const Text('Vermögensaufteilung konnte nicht geladen werden.');
              }
              return const LoadingIndicator();
          }
        },
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(_percentageStats.length, (i) {
      return PieChartSectionData(
        color: _percentageStats[i].statColor,
        value: _percentageStats[i].percentage.abs(),
        title: _percentageStats[i].percentage.abs().toStringAsFixed(1).replaceAll('.', ',') + '%',
        badgeWidget: Text(_percentageStats[i].name),
        badgePositionPercentageOffset: 1.3,
        radius: 46.0,
        titleStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      );
    });
  }
}
