import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '/models/booking.dart';
import '/models/percentage_stats.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';
import '/models/enums/outcome_statistic_types.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../buttons/expenditure_stats_button.dart';
import '../buttons/transaction_stats_button.dart';

import '../cards/percentage_card.dart';

import '../deco/loading_indicator.dart';

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
        return _loadMonthlyExpenditureSavingsrateAndInvestmentrateStatistic();
      }
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      return _loadMonthlyRevenueStatistic();
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      return _loadMonthlyInvestmentStatistic();
    }
    return _loadMonthlyExpenditureStatistic();
  }

  Future<List<PercentageStats>> _loadMonthlyExpenditureStatistic() async {
    _percentageStats = [];
    _totalExpenditures = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalExpenditures);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  Future<List<PercentageStats>> _loadMonthlyExpenditureAndSavingsrateStatistic() async {
    _percentageStats = [];
    _totalExpenditures = 0.0;
    _totalRevenues = 0.0;
    double totalSavings = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    if (_bookingList.isEmpty) {
      return [];
    }
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
      } else if (_bookingList[i].transactionType == TransactionType.income.name) {
        _totalRevenues += formatMoneyAmountToDouble(_bookingList[i].amount);
      }
    }
    totalSavings = _totalRevenues - _totalExpenditures;
    _percentageStats = PercentageStats.createOrUpdatePercentageStats(
        0, formatToMoneyAmount(totalSavings.toString()), _percentageStats, OutcomeStatisticType.savingrate.name, categorieStatsAreUpdated);
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  Future<List<PercentageStats>> _loadMonthlyExpenditureSavingsrateAndInvestmentrateStatistic() async {
    _percentageStats = [];
    _totalExpenditures = 0.0;
    _totalRevenues = 0.0;
    double totalSavings = 0.0;
    double totalInvestments = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    if (_bookingList.isEmpty) {
      return [];
    }
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, categorieStatsAreUpdated);
      } else if (_bookingList[i].transactionType == TransactionType.income.name) {
        _totalRevenues += formatMoneyAmountToDouble(_bookingList[i].amount);
      } else if (_bookingList[i].transactionType == TransactionType.investment.name) {
        totalInvestments += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats =
            PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, OutcomeStatisticType.investmentrate.name, categorieStatsAreUpdated);
      }
    }
    totalSavings = _totalRevenues - _totalExpenditures - totalInvestments;
    _percentageStats = PercentageStats.createOrUpdatePercentageStats(0, formatToMoneyAmount(totalSavings.toString()), _percentageStats, 'Sparquote', categorieStatsAreUpdated);
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures + totalInvestments);
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
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.6,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: PieChart(
                          PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 4.0,
                            centerSpaceRadius: 40.0,
                            sections: showingEmptyDiagram(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: _currentCategorieType == CategorieType.income.pluralName ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                      children: [
                        TransactionStatsButton(
                          categorieType: _currentCategorieType,
                          selectedCategorieTypeCallback: (String categorieType) => setState(() => _currentCategorieType = categorieType),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _currentCategorieType == CategorieType.outcome.pluralName
                                ? ExpenditureStatsButton(
                                    outcomeStatisticType: _currentOutcomeStatisticType,
                                    selectedOutcomeStatisticTypeCallback: (String outcomeStatisticType) => setState(() => _currentOutcomeStatisticType = outcomeStatisticType),
                                    expenditureFunction: _loadMonthlyExpenditureStatistic,
                                    expenditureAndSavingrateFunction: _loadMonthlyExpenditureAndSavingsrateStatistic,
                                    expenditureSavingrateAndInvestmentrateFunction: _loadMonthlyExpenditureSavingsrateAndInvestmentrateStatistic,
                                  )
                                : _currentCategorieType == CategorieType.investment.pluralName
                                    ? const Text('Einzelne Investments:')
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
                    Expanded(
                      child: Center(
                        child: Text('Noch keine $_currentCategorieType vorhanden.'),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
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
                  ),
                  Row(
                    mainAxisAlignment: _currentCategorieType == CategorieType.income.pluralName ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                    children: [
                      TransactionStatsButton(
                        categorieType: _currentCategorieType,
                        selectedCategorieTypeCallback: (String categorieType) => setState(() => _currentCategorieType = categorieType),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _currentCategorieType == CategorieType.outcome.pluralName
                              ? ExpenditureStatsButton(
                                  outcomeStatisticType: _currentOutcomeStatisticType,
                                  selectedOutcomeStatisticTypeCallback: (String outcomeStatisticType) => setState(() => _currentOutcomeStatisticType = outcomeStatisticType),
                                  expenditureFunction: _loadMonthlyExpenditureStatistic,
                                  expenditureAndSavingrateFunction: _loadMonthlyExpenditureAndSavingsrateStatistic,
                                  expenditureSavingrateAndInvestmentrateFunction: _loadMonthlyExpenditureSavingsrateAndInvestmentrateStatistic,
                                )
                              : _currentCategorieType == CategorieType.investment.pluralName
                                  ? const Text('Einzelne Investments:')
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
                      height: 259.0,
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

  List<PieChartSectionData> showingEmptyDiagram() {
    return List.generate(1, (i) {
      return PieChartSectionData(
        color: Colors.grey,
        value: 100,
        title: '',
        badgeWidget: const Text(''),
        badgePositionPercentageOffset: 1.3,
        radius: 50.0,
      );
    });
  }
}
