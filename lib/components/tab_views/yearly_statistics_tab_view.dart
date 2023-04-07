import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/booking.dart';
import '/models/categorie_stats.dart';
import '/models/enums/transaction_types.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../cards/expenditure_card.dart';

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
  List<CategorieStats> _categorieStats = [];
  double _totalExpenditures = 0.0;
  bool _showSavingsRate = true;

  Future<List<CategorieStats>> _loadYearlyExpendituresStatistic() async {
    _categorieStats = [];
    _totalExpenditures = 0.0;
    bool categorieStatsAreUpdated = false;
    List<Booking> _bookingList = [];
    for (int i = 0; i < 12; i++) {
      _bookingList = await Booking.loadMonthlyBookingList(i + 1, widget.selectedDate.year);
      for (int i = 0; i < _bookingList.length; i++) {
        if (_bookingList[i].transactionType == TransactionType.outcome.name || (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name)) {
          categorieStatsAreUpdated = false;
          _totalExpenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
          if (_showSavingsRate && _bookingList[i].transactionType == TransactionType.investment.name) {
            _categorieStats = CategorieStats.createOrUpdateCategorieStats(i, _bookingList, _categorieStats, 'Investition', categorieStatsAreUpdated, Colors.cyanAccent);
          } else {
            _categorieStats = CategorieStats.createOrUpdateCategorieStats(
                i, _bookingList, _categorieStats, _bookingList[i].categorie, categorieStatsAreUpdated, Color.fromRGBO((i * 20) % 255, (i * 20) % 255, (i * 50) % 255, 0.8));
          }
        }
      }
    }
    _categorieStats = CategorieStats.calculateCategoriePercentage(_categorieStats, _totalExpenditures);
    _categorieStats.sort((first, second) => second.percentage.compareTo(first.percentage));
    return _categorieStats;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadYearlyExpendituresStatistic(),
      builder: (BuildContext context, AsyncSnapshot<List<CategorieStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_categorieStats.isEmpty) {
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Sparquote anzeigen:'),
                      Switch(
                        value: _showSavingsRate,
                        onChanged: (value) {
                          setState(() {
                            _showSavingsRate = value;
                          });
                        },
                      ),
                    ],
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _categorieStats = await _loadYearlyExpendituresStatistic();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 275.0,
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
              return const Text('Jährliche Statistiken konnten nicht geladen werden.');
            }
            return const LoadingIndicator();
        }
      },
    );
  }

  List<PieChartSectionData> showingSections() {
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
