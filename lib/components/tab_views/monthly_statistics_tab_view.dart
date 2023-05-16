import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  double _totalSavings = 0.0;
  double _savingRate = 0.0;
  double _totalExpenditures = 0.0;
  double _totalRevenues = 0.0;
  double _totalInvestments = 0.0;
  double _investmentRate = 0.0;

  Future<List<PercentageStats>> _loadMonthlyStatistic() async {
    _totalSavings = await _getMonthlySavings();
    _totalInvestments = await _getMonthlyInvestments();
    _savingRate = await _getMonthlySavingRate();
    _investmentRate = await _getMonthlyInvestmentRate();
    if (_currentCategorieType == CategorieType.outcome.pluralName) {
      return _loadMonthlyExpenditureStatistic();
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      return _loadMonthlyRevenueStatistic();
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      return _loadMonthlyInvestmentStatistic();
    }
    return _loadMonthlyExpenditureStatistic();
  }

  Future<double> _getMonthlySavings() async {
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    double totalRevenues = Booking.getRevenues(_bookingList);
    double totalExpenditures = Booking.getExpenditures(_bookingList);
    double totalInvestments = Booking.getInvestments(_bookingList);
    return totalRevenues - totalExpenditures - totalInvestments;
  }

  Future<double> _getMonthlySavingRate() async {
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    double totalRevenues = Booking.getRevenues(_bookingList);
    return (_totalSavings * 100) / totalRevenues;
  }

  Future<double> _getMonthlyInvestments() async {
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    return Booking.getInvestments(_bookingList);
  }

  Future<double> _getMonthlyInvestmentRate() async {
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    double totalInvestments = Booking.getInvestments(_bookingList);
    double totalRevenues = Booking.getRevenues(_bookingList);
    return (totalInvestments * 100) / totalRevenues;
  }

  Future<double> _getMonthlyOverallSavingRate() async {
    return _savingRate - _investmentRate;
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
    if (totalSavings <= 0.0) {
      _percentageStats = [];
      _percentageStats =
          PercentageStats.createOrUpdatePercentageStats(0, formatToMoneyAmount('0'), _percentageStats, OutcomeStatisticType.savingrate.name, categorieStatsAreUpdated);
      _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures);
    } else {
      _percentageStats = PercentageStats.createOrUpdatePercentageStats(
          0, formatToMoneyAmount(totalSavings.toString()), _percentageStats, OutcomeStatisticType.savingrate.name, categorieStatsAreUpdated);
      _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures);
    }
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
    if (totalSavings <= 0.0) {
      _percentageStats = [];
      _percentageStats = PercentageStats.createOrUpdatePercentageStats(0, formatToMoneyAmount('0'), _percentageStats, 'Sparquote', categorieStatsAreUpdated);
      _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures + totalInvestments);
    } else {
      _percentageStats = PercentageStats.createOrUpdatePercentageStats(0, formatToMoneyAmount(totalSavings.toString()), _percentageStats, 'Sparquote', categorieStatsAreUpdated);
      _percentageStats = PercentageStats.calculatePercentage(_percentageStats, totalSavings + _totalExpenditures + totalInvestments);
    }
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
        _percentageStats = PercentageStats.showSeparatePercentages(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie);
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, _totalInvestments);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(_percentageStats.length, (i) {
      return PieChartSectionData(
        color: _percentageStats[i].statColor,
        value: _percentageStats[i].percentage,
        title: _percentageStats[i].percentage.toStringAsFixed(1).replaceAll('.', ',') + '%',
        badgeWidget: Text(_percentageStats[i].name),
        badgePositionPercentageOffset: 1.3,
        radius: 46.0,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TransactionStatsButton(
                        categorieType: _currentCategorieType,
                        selectedCategorieTypeCallback: (String categorieType) => setState(() => _currentCategorieType = categorieType),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 4.0,
                          centerSpaceRadius: 30.0,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 2.0,
                                  percent: _savingRate / 100,
                                  center: Text('${_savingRate.toStringAsFixed(0)}%'),
                                  progressColor: Colors.cyanAccent,
                                  backgroundWidth: 1.0,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  animation: true,
                                  animateFromLastPercent: true,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatToMoneyAmount(_totalSavings.toString())),
                                  const Text('Gespart', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 6.0, 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(color: Colors.cyanAccent),
                                ),
                                child: Text(formatToMoneyAmount((_totalSavings + _totalInvestments).toString())),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(formatToMoneyAmount(_totalInvestments.toString())),
                                  const Text('Investiert', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 2.0,
                                  percent: _investmentRate / 100,
                                  center: Text('${_investmentRate.toStringAsFixed(0)}%'),
                                  progressColor: Colors.cyanAccent,
                                  backgroundWidth: 1.0,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  animation: true,
                                  animateFromLastPercent: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _percentageStats = await _loadMonthlyStatistic();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 250.0,
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
}
