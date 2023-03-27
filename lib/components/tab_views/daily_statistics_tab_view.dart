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
  List<CategorieStats> _categorieStats = [];
  double _totalExpenditures = 0.0;

  Future<List<CategorieStats>> _loadMonthlyExpenditureStatistic() async {
    _categorieStats = [];
    _totalExpenditures = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        categorieStatsAreUpdated = false;
        _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
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
    _calculateMonthlyExpenditurePercentage();
    _categorieStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _categorieStats;
  }

  void _calculateMonthlyExpenditurePercentage() {
    for (int i = 0; i < _categorieStats.length; i++) {
      _categorieStats[i].percentage = (formatMoneyAmountToDouble(_categorieStats[i].amount) * 100) / _totalExpenditures;
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
    // TODO hier weitermachen und klicken deaktivieren auf Diagramm und anschließend Buchungen wiederholt ausführen implementieren
    return List.generate(_categorieStats.length, (i) {
      return PieChartSectionData(
        color: _categorieStats[i].statColor,
        value: _categorieStats[i].percentage,
        title: _categorieStats[i].percentage.toStringAsFixed(1) + '%',
        badgeWidget: Text(_categorieStats[i].categorieName),
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
