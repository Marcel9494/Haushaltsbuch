import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/booking.dart';
import '/models/percentage_stats.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../cards/percentage_card.dart';

import '../deco/loading_indicator.dart';

class YearlyStatisticsTabView extends StatefulWidget {
  final DateTime selectedDate;

  const YearlyStatisticsTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<YearlyStatisticsTabView> createState() => _YearlyStatisticsTabViewState();
}

class _YearlyStatisticsTabViewState extends State<YearlyStatisticsTabView> {
  List<PercentageStats> _percentageStats = [];
  String _currentCategorieType = CategorieType.outcome.pluralName;
  double _totalExpenditures = 0.0;
  double _totalRevenues = 0.0;
  double _totalInvestments = 0.0;
  bool _showSavingsRate = true;
  bool _showSeparateInvestments = true;

  // TODO hier weitermachen und gleich implementieren wie bei monthly_statistics_tab_view nur nicht auf
  // Monatsbasis, sondern auf Jahresbasis + ebenfalls gemeinsame Widgets einbinden
  Future<List<PercentageStats>> _loadYearlyExpenditureStatistic() async {
    _percentageStats = [];
    _totalExpenditures = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = [];
    for (int i = 0; i < 12; i++) {
      _bookingList.addAll(await Booking.loadMonthlyBookingList(i + 1, widget.selectedDate.year));
    }
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name || (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name)) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        if (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name) {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, 'Investition', categorieStatsAreUpdated);
        } else {
          _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
        }
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalExpenditures);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  Future<List<PercentageStats>> _loadYearlyRevenueStatistic() async {
    _percentageStats = [];
    _totalRevenues = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = [];
    for (int i = 0; i < 12; i++) {
      _bookingList.addAll(await Booking.loadMonthlyBookingList(i + 1, widget.selectedDate.year));
    }
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

  Future<List<PercentageStats>> _loadYearlyInvestmentStatistic() async {
    _percentageStats = [];
    _totalInvestments = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = [];
    for (int i = 0; i < 12; i++) {
      _bookingList.addAll(await Booking.loadMonthlyBookingList(i + 1, widget.selectedDate.year));
    }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _currentCategorieType == CategorieType.outcome.pluralName
          ? _loadYearlyExpenditureStatistic()
          : _currentCategorieType == CategorieType.income.pluralName
              ? _loadYearlyRevenueStatistic()
              : _loadYearlyInvestmentStatistic(),
      builder: (BuildContext context, AsyncSnapshot<List<PercentageStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_percentageStats.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('Noch keine Ausgaben vorhanden.'),
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
                    mainAxisAlignment: _currentCategorieType == CategorieType.income.pluralName ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
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
                              ? const Text('Sparquote anzeigen:')
                              : _currentCategorieType == CategorieType.investment.pluralName
                                  ? const Text('Einzelne Positionen:')
                                  : const SizedBox(),
                          _currentCategorieType == CategorieType.outcome.pluralName || _currentCategorieType == CategorieType.investment.pluralName
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
                      _percentageStats = await _loadYearlyExpenditureStatistic();
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
            }
          default:
            if (snapshot.hasError) {
              return const Text('Jährliche Statistiken konnten nicht geladen werden.');
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
