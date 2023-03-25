import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '/models/categorie_stats.dart';
import '/models/enums/transaction_types.dart';
import '/models/booking.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../cards/expenditure_card.dart';

import '../deco/loading_indicator.dart';

class DailyStatisticsTabView extends StatefulWidget {
  final DateTime selectedDate;

  const DailyStatisticsTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<DailyStatisticsTabView> createState() => _DailyStatisticsTabViewState();
}

class _DailyStatisticsTabViewState extends State<DailyStatisticsTabView> {
  int _touchedIndex = -1;
  List<CategorieStats> _categorieStats = [];
  double _monthlyExpenditures = 0.0;

  Future<List<CategorieStats>> _loadMonthlyExpenditureStatistic() async {
    double totalExpenditures = 0.0;
    _categorieStats = [];
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
        if (i == 0) {
          CategorieStats newCategorieStats = CategorieStats()
            ..categorieName = _bookingList[i].categorie
            ..amount = _bookingList[i].amount
            ..percentage = 0.0
            ..statColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.6);
          _categorieStats.add(newCategorieStats);
        } else {
          for (int j = 0; j < _categorieStats.length; j++) {
            if (_categorieStats[j].categorieName.contains(_bookingList[i].categorie)) {
              double amount = formatMoneyAmountToDouble(_categorieStats[j].amount);
              amount += formatMoneyAmountToDouble(_bookingList[i].amount);
              _categorieStats[j].amount = formatToMoneyAmount(amount.toString());
              categorieStatsAreUpdated = true;
              break;
            }
          }
          if (categorieStatsAreUpdated == false) {
            CategorieStats newCategorieStats = CategorieStats()
              ..categorieName = _bookingList[i].categorie
              ..amount = _bookingList[i].amount
              ..percentage = 0.0
              ..statColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.6);
            _categorieStats.add(newCategorieStats);
          }
        }
      }
    }
    _calculateMonthlyExpenditurePercentage(totalExpenditures);
    _categorieStats.sort((first, second) => second.amount.compareTo(first.amount));
    return _categorieStats;
  }

  void _calculateMonthlyExpenditurePercentage(double totalExpenditures) {
    for (int i = 0; i < _categorieStats.length; i++) {
      _categorieStats[i].percentage = (formatMoneyAmountToDouble(_categorieStats[i].amount) * 100) / totalExpenditures;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadMonthlyExpenditureStatistic(),
      builder: (BuildContext context, AsyncSnapshot<List<CategorieStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_categorieStats.isEmpty) {
              return const Text('Noch keine Kostenstellen vorhanden.');
            } else {
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _categorieStats = await _loadMonthlyExpenditureStatistic();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 325.0,
                      child: ListView.builder(
                        itemCount: _categorieStats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpenditureCard(categorieStats: _categorieStats[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          default:
            if (snapshot.hasError) {
              return const Text('Konten Übersicht konnte nicht geladen werden.');
            }
            return const LoadingIndicator();
        }
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(_categorieStats.length, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: _categorieStats[i].statColor,
        value: _categorieStats[i].percentage,
        title: _categorieStats[i].percentage.toStringAsFixed(1) + '%',
        badgeWidget: Text(_categorieStats[i].categorieName),
        badgePositionPercentageOffset: 1.3,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      );
    });
  }
}
