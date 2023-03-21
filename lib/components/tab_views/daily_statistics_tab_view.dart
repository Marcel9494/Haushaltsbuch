import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../cards/expenditure_card.dart';
import '../deco/loading_indicator.dart';

class DailyStatisticsTabView extends StatefulWidget {
  const DailyStatisticsTabView({Key? key}) : super(key: key);

  @override
  State<DailyStatisticsTabView> createState() => _DailyStatisticsTabViewState();
}

class _DailyStatisticsTabViewState extends State<DailyStatisticsTabView> {
  int _touchedIndex = -1;
  List<double> _categorieCostsList = [];

  Future<List<double>> _loadCategorieCostsList() async {
    for (int i = 0; i < 10; i++) {
      _categorieCostsList.add(i.toDouble());
    }
    return _categorieCostsList;
  }

  @override
  Widget build(BuildContext context) {
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
        FutureBuilder(
          future: _loadCategorieCostsList(),
          builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const LoadingIndicator();
              case ConnectionState.done:
                if (_categorieCostsList.isEmpty) {
                  return const Text('Noch keine Kostenstellen vorhanden.');
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _categorieCostsList = await _loadCategorieCostsList();
                      setState(() {});
                      return;
                    },
                    color: Colors.cyanAccent,
                    child: SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        itemCount: _categorieCostsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return const ExpenditureCard();
                        },
                      ),
                    ),
                  );
                }
              default:
                if (snapshot.hasError) {
                  return const Text('Konten Übersicht konnte nicht geladen werden.');
                }
                return const LoadingIndicator();
            }
          },
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellowAccent,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
