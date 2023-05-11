import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/models/booking.dart';
import '/models/percentage_stats.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';
import '/models/enums/outcome_statistic_types.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../cards/percentage_card.dart';

import '../deco/loading_indicator.dart';
import '../deco/bottom_sheet_line.dart';

class MonthlyStatisticsTabView extends StatefulWidget {
  final DateTime selectedDate;

  const MonthlyStatisticsTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<MonthlyStatisticsTabView> createState() => _MonthlyStatisticsTabViewState();
}

class _MonthlyStatisticsTabViewState extends State<MonthlyStatisticsTabView> {
  List<PercentageStats> _percentageStats = [];
  String _currentCategorieType = CategorieType.outcome.pluralName;
  String _currentOutcomeStatisticType = OutcomeStatisticType.outcome.name;
  double _totalExpenditures = 0.0;
  double _totalRevenues = 0.0;
  double _totalInvestments = 0.0;
  bool _showSavingsRate = true;
  bool _showSeparateInvestments = true;

  Future<List<PercentageStats>> _loadMonthlyStatistic() {
    if (_currentCategorieType == CategorieType.outcome.pluralName) {
      if (_currentOutcomeStatisticType == OutcomeStatisticType.outcome.name) {
        return _loadMonthlyExpenditureStatistic();
      } else if (_currentOutcomeStatisticType == OutcomeStatisticType.savingrate.name) {
        return _loadMonthlyExpenditureAndSavingsrateStatistic();
      } else if (_currentOutcomeStatisticType == OutcomeStatisticType.investmentrate.name) {
        // TODO Funktion muss noch implementiert werden
      }
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      return _loadMonthlyRevenueStatistic();
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      return _loadMonthlyInvestmentStatistic();
    }
    return _loadMonthlyExpenditureStatistic();
  }

  Future<List<PercentageStats>> _loadMonthlyExpenditureStatistic() async {
    _currentOutcomeStatisticType = OutcomeStatisticType.outcome.name;
    _percentageStats = [];
    _totalExpenditures = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name || (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name)) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        if (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name) {
          _percentageStats =
              PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, CategorieType.investment.pluralName, categorieStatsAreUpdated);
        } else {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
        }
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalExpenditures);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  // TODO hier weitermachen und Sparquote noch die richtigen Prozente berechnen
  Future<List<PercentageStats>> _loadMonthlyExpenditureAndSavingsrateStatistic() async {
    _currentOutcomeStatisticType = OutcomeStatisticType.savingrate.name;
    _percentageStats = [];
    _totalExpenditures = 0.0;
    _totalRevenues = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
      } else if (_bookingList[i].transactionType == TransactionType.income.name) {
        _totalRevenues += formatMoneyAmountToDouble(_bookingList[i].amount);
      }
    }
    double _totalSavings = _totalRevenues - _totalExpenditures;
    _percentageStats = PercentageStats.createOrUpdatePercentageStats(0, _totalSavings.toString(), _percentageStats, 'Sparquote', categorieStatsAreUpdated);
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalSavings);
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalExpenditures);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  Future<List<PercentageStats>> _loadMonthlyRevenueStatistic() async {
    _percentageStats = [];
    _totalRevenues = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.income.name) {
        categorieStatsAreUpdated = false;
        _totalRevenues += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalRevenues);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  Future<List<PercentageStats>> _loadMonthlyInvestmentStatistic() async {
    _percentageStats = [];
    _totalInvestments = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.investment.name) {
        categorieStatsAreUpdated = false;
        _totalInvestments += formatMoneyAmountToDouble(_bookingList[i].amount);
        if (_showSeparateInvestments && _bookingList[i].transactionType == TransactionType.investment.name) {
          _percentageStats = PercentageStats.showSeparatePercentages(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie);
        } else {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
        }
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalInvestments);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  void _changeCategorieType() {
    if (_currentCategorieType == CategorieType.outcome.pluralName) {
      _currentCategorieType = CategorieType.income.pluralName;
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      _currentCategorieType = CategorieType.investment.pluralName;
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      _currentCategorieType = CategorieType.outcome.pluralName;
    }
    setState(() {});
  }

  void _openBottomSheetMenu(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: ListView(
            shrinkWrap: true,
            children: [
              const BottomSheetLine(),
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 20.0),
                child: Text('Auswählen:', style: TextStyle(fontSize: 18.0)),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () => {
                      _loadMonthlyExpenditureStatistic(),
                      Navigator.pop(context),
                      setState(() {}),
                    },
                    leading: const Icon(Icons.local_grocery_store_rounded, color: Colors.cyanAccent),
                    title: const Text('Nur Ausgaben'),
                  ),
                  ListTile(
                    onTap: () => {
                      _loadMonthlyExpenditureAndSavingsrateStatistic(),
                      Navigator.pop(context),
                      setState(() {}),
                    },
                    leading: const Icon(Icons.savings_rounded, color: Colors.cyanAccent),
                    title: const Text('Ausgaben + Sparquote'),
                  ),
                  ListTile(
                    onTap: () => {
                      _loadMonthlyExpenditureStatistic(),
                      Navigator.pop(context),
                      setState(() {}),
                    },
                    leading: const Icon(Icons.volunteer_activism_rounded, color: Colors.cyanAccent),
                    title: const Text('Ausgaben + Spar- & Investitionsquote'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadMonthlyStatistic(),
      builder: (BuildContext context, AsyncSnapshot<List<PercentageStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_percentageStats.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text('Noch keine $_currentCategorieType vorhanden.'),
                ),
              );
            } else {
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
                  Row(
                    mainAxisAlignment: _currentCategorieType == CategorieType.income.pluralName ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: _currentCategorieType == CategorieType.income.pluralName ? const EdgeInsets.only(left: 12.0) : const EdgeInsets.all(0.0),
                        child: OutlinedButton(
                          onPressed: () => _changeCategorieType(),
                          child: Text(
                            _currentCategorieType,
                            style: const TextStyle(color: Colors.cyanAccent),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _currentCategorieType == CategorieType.outcome.pluralName
                              ? OutlinedButton(
                                  onPressed: () => _openBottomSheetMenu(context),
                                  child: Text(
                                    _currentOutcomeStatisticType,
                                    style: const TextStyle(color: Colors.cyanAccent),
                                  ),
                                )
                              : _currentCategorieType == CategorieType.investment.pluralName
                                  ? const Text('Einzelne Positionen:')
                                  : const SizedBox(),
                          _currentCategorieType == CategorieType.investment.pluralName
                              ? Switch(
                                  value: _currentCategorieType == CategorieType.investment.pluralName ? _showSeparateInvestments : _showSavingsRate,
                                  onChanged: (value) {
                                    setState(() {
                                      _currentCategorieType == CategorieType.investment.pluralName ? _showSeparateInvestments = value : _showSavingsRate = value;
                                    });
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _percentageStats = await _loadMonthlyStatistic();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 275.0,
                      child: ListView.builder(
                        itemCount: _percentageStats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PercentageCard(percentageStats: _percentageStats[index], selectedDate: widget.selectedDate);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          default:
            if (snapshot.hasError) {
              return const Text('Monatliche Statistiken konnten nicht geladen werden.');
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
