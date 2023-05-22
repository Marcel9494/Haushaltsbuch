import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '/models/booking.dart';
import '/models/percentage_stats.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';

import '/utils/number_formatters/number_formatter.dart';

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
  List<Booking> _bookingList = [];
  String _currentCategorieType = CategorieType.outcome.pluralName;
  double _totalSavings = 0.0;
  double _savingPercentage = 0.0;
  double _totalInvestments = 0.0;
  double _investmentPercentage = 0.0;

  Future<List<PercentageStats>> _loadStatistics() async {
    _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    _totalSavings = await _getMonthlySavings();
    _totalInvestments = Booking.getInvestments(_bookingList);
    _savingPercentage = await _getMonthlySavingRate();
    _investmentPercentage = await _getMonthlyInvestmentRate();
    if (_currentCategorieType == CategorieType.outcome.pluralName) {
      return _loadMonthlyStatistic(TransactionType.outcome);
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      return _loadMonthlyStatistic(TransactionType.income);
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      return _loadMonthlyStatistic(TransactionType.investment);
    }
    return _loadMonthlyStatistic(TransactionType.outcome);
  }

  Future<double> _getMonthlySavings() async {
    double totalRevenues = Booking.getRevenues(_bookingList);
    double totalExpenditures = Booking.getExpenditures(_bookingList);
    double totalInvestments = Booking.getInvestments(_bookingList);
    return totalRevenues - totalExpenditures - totalInvestments;
  }

  Future<double> _getMonthlySavingRate() async {
    double totalRevenues = Booking.getRevenues(_bookingList);
    if (totalRevenues <= 0.0) {
      return 0.0;
    }
    return (_totalSavings * 100) / totalRevenues;
  }

  Future<double> _getMonthlyInvestmentRate() async {
    double totalInvestments = Booking.getInvestments(_bookingList);
    double totalRevenues = Booking.getRevenues(_bookingList);
    if (totalRevenues <= 0.0) {
      return 0.0;
    }
    return (totalInvestments * 100) / totalRevenues;
  }

  Future<List<PercentageStats>> _loadMonthlyStatistic(TransactionType transactionType) async {
    _percentageStats = [];
    double total = 0.0;
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == transactionType.name) {
        total += formatMoneyAmountToDouble(_bookingList[i].amount);
        _percentageStats = PercentageStats.createOrUpdatePercentageStats(i, _bookingList[i].amount, _percentageStats, _bookingList[i].categorie, false);
      }
    }
    _percentageStats = PercentageStats.calculatePercentage(_percentageStats, total);
    _percentageStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _percentageStats;
  }

  double _checkPercentageValue(double value) {
    if (value / 100 >= 1.0) {
      return 1.0;
    } else if (value / 100 <= 0.0) {
      return 0.0;
    }
    return value / 100;
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(_percentageStats.length, (i) {
      return PieChartSectionData(
        color: _percentageStats[i].statColor,
        value: _percentageStats[i].percentage,
        title: _percentageStats[i].percentage.toStringAsFixed(1).replaceAll('.', ',') + '%',
        badgeWidget: Text(_percentageStats[i].name, style: const TextStyle(fontSize: 10.0)),
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

  List<PieChartSectionData> _showingEmptyDiagram() {
    return List.generate(1, (i) {
      return PieChartSectionData(
        color: Colors.grey,
        value: 100,
        title: '',
        badgeWidget: const Text(''),
        badgePositionPercentageOffset: 1.3,
        radius: 46.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadStatistics(),
      builder: (BuildContext context, AsyncSnapshot<List<PercentageStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_percentageStats.isEmpty) {
              return Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: _currentCategorieType == CategorieType.income.pluralName ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                      children: [
                        TransactionStatsButton(
                          categorieType: _currentCategorieType,
                          selectedCategorieTypeCallback: (String categorieType) => setState(() => _currentCategorieType = categorieType),
                        ),
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: 2.0,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 4.0,
                          centerSpaceRadius: 30.0,
                          sections: _showingEmptyDiagram(),
                        ),
                      ),
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
                          sections: _showingSections(),
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
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 2.0,
                                  percent: _checkPercentageValue(_savingPercentage),
                                  center: Text('${_savingPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.0)),
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
                                  Text(formatToMoneyAmount(_totalSavings.toString()), style: const TextStyle(fontSize: 12.0)),
                                  const Text('Gespart', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 2.0,
                                  percent: _checkPercentageValue(_investmentPercentage),
                                  center: Text('${_investmentPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.0)),
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
                                  Text(formatToMoneyAmount(_totalInvestments.toString()), style: const TextStyle(fontSize: 12.0)),
                                  const Text('Investiert', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 2.0,
                                  percent: _checkPercentageValue(_savingPercentage),
                                  center: Text('${_savingPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.0)),
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
                                  Text(formatToMoneyAmount((_totalSavings + _totalInvestments).toString()), style: const TextStyle(fontSize: 12.0)),
                                  const Text('Gesamt', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _percentageStats = await _loadStatistics();
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
