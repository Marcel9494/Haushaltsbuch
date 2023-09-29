import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:haushaltsbuch/models/booking/booking_repository.dart';

import '/models/booking/booking_model.dart';
import '/models/percentage_stats.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../buttons/transaction_stats_toggle_buttons.dart';

import '../cards/categorie_percentage_card.dart';

import '../deco/loading_indicator.dart';

class MonthlyStatisticsTabView extends StatefulWidget {
  final DateTime selectedDate;

  const MonthlyStatisticsTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<MonthlyStatisticsTabView> createState() => _MonthlyStatisticsTabViewState();

  static _MonthlyStatisticsTabViewState? of(BuildContext context) => context.findAncestorStateOfType<_MonthlyStatisticsTabViewState>();
}

class _MonthlyStatisticsTabViewState extends State<MonthlyStatisticsTabView> {
  List<PercentageStats> _percentageStats = [];
  List<Booking> _bookingList = [];
  String _currentCategorieType = CategorieType.outcome.pluralName;

  set currentCategorieType(String categorie) => setState(() => {_currentCategorieType = categorie});

  Future<List<PercentageStats>> _loadStatistics() async {
    BookingRepository bookingRepository = BookingRepository();
    _bookingList = await bookingRepository.loadMonthlyBookingList(widget.selectedDate.month, widget.selectedDate.year);
    if (_currentCategorieType == CategorieType.outcome.pluralName) {
      return _loadMonthlyStatistic(TransactionType.outcome);
    } else if (_currentCategorieType == CategorieType.income.pluralName) {
      return _loadMonthlyStatistic(TransactionType.income);
    } else if (_currentCategorieType == CategorieType.investment.pluralName) {
      return _loadMonthlyStatistic(TransactionType.investment);
    }
    return _loadMonthlyStatistic(TransactionType.outcome);
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
            return const SizedBox();
          case ConnectionState.done:
            if (_percentageStats.isEmpty) {
              return Expanded(
                child: Column(
                  children: [
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
                            sections: _showingEmptyDiagram(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TransactionStatsToggleButtons(currentTransaction: _currentCategorieType, monthlyStatistics: true),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TransactionStatsToggleButtons(currentTransaction: _currentCategorieType, monthlyStatistics: true),
                    ],
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      _percentageStats = await _loadStatistics();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 300.0, // TODO dynamisch machen
                      child: ListView.builder(
                        itemCount: _percentageStats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoriePercentageCard(percentageStats: _percentageStats[index], selectedDate: widget.selectedDate, bookingList: _bookingList);
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
