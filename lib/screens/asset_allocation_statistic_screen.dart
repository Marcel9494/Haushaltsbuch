import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../components/cards/percentage_card.dart';
import '../components/deco/loading_indicator.dart';
import '../models/account.dart';
import '/models/percentage_stats.dart';

class AssetAllocationStatisticScreen extends StatefulWidget {
  const AssetAllocationStatisticScreen({Key? key}) : super(key: key);

  @override
  State<AssetAllocationStatisticScreen> createState() => _AssetAllocationStatisticScreenState();
}

class _AssetAllocationStatisticScreenState extends State<AssetAllocationStatisticScreen> {
  List<PercentageStats> _percentageStats = [];
  double _totalAssets = 0.0;

  Future<List<PercentageStats>> _loadAssetAllocationStatistic() async {
    _percentageStats = [];
    bool categorieStatsAreUpdated = false;
    _totalAssets = await Account.getAssetValue();
    List<Account> _accountList = await Account.loadAccounts();
    for (int i = 0; i < _accountList.length; i++) {
      categorieStatsAreUpdated = false;
      _percentageStats =
          PercentageStats.createOrUpdatePercentageStats(i, _accountList[i].bankBalance, _percentageStats, _accountList[i].accountType, categorieStatsAreUpdated, Colors.cyanAccent);
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalAssets);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAssetAllocationStatistic(),
      builder: (BuildContext context, AsyncSnapshot<List<PercentageStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 4.0,
                      centerSpaceRadius: 40.0,
                      sections: showingSections(),
                    ),
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
                    height: 275.0,
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
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(_percentageStats.length, (i) {
      return PieChartSectionData(
        color: _percentageStats[i].statColor,
        value: _percentageStats[i].percentage,
        title: _percentageStats[i].percentage.toStringAsFixed(1) + '%',
        badgeWidget: Text(_percentageStats[i].name),
        badgePositionPercentageOffset: 1.3,
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      );
    });
  }
}
