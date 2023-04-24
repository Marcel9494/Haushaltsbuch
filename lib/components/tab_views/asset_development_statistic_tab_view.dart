import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/account.dart';
import '/models/booking.dart';
import '/models/wealth_development_stats.dart';

class AssetDevelopmentStatisticTabView extends StatefulWidget {
  const AssetDevelopmentStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetDevelopmentStatisticTabView> createState() => _AssetDevelopmentStatisticTabViewState();
}

class _AssetDevelopmentStatisticTabViewState extends State<AssetDevelopmentStatisticTabView> {
  List<Color> gradientColors = [Colors.cyanAccent, Colors.cyan];
  bool showAvg = false;
  double _assets = 0.0;
  double _liabilities = 0.0;
  double _maxWealthValue = 0.0;
  double _currentYearPeriod = 1;
  List<WealthDevelopmentStats> _wealthDevelopmentStats = [];
  List<bool> _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false];

  Future<List<WealthDevelopmentStats>> _loadChartBarData() async {
    _wealthDevelopmentStats = [];
    _assets = await Account.getAssetValue();
    _liabilities = await Account.getLiabilityValue();
    List<double> wealthValues = [];
    List<double> monthRevenues = [];
    List<double> monthExpenditures = [];
    List<double> monthInvestments = [];
    for (int i = 0; i < 12; i++) {
      List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i + 1, DateTime.now().year);
      monthRevenues.add(Booking.getRevenues(_bookingList));
      monthExpenditures.add(Booking.getExpenditures(_bookingList));
      monthInvestments.add(Booking.getInvestments(_bookingList));
      WealthDevelopmentStats wealthDevelopmentStat = WealthDevelopmentStats();
      wealthDevelopmentStat.month = i.toString();
      wealthDevelopmentStat.wealth = 0.0;
      _wealthDevelopmentStats.add(wealthDevelopmentStat);
    }
    for (int i = DateTime.now().month; i > 0; i--) {
      WealthDevelopmentStats wealthDevelopmentStat = WealthDevelopmentStats();
      wealthDevelopmentStat.wealth = _assets - _liabilities;
      wealthDevelopmentStat.month = i.toString();
      for (int j = DateTime.now().month; j >= i; j--) {
        wealthDevelopmentStat.wealth += monthExpenditures[j];
      }
      wealthValues.add(wealthDevelopmentStat.wealth);
      _wealthDevelopmentStats[_wealthDevelopmentStats.indexWhere((element) => element.month == wealthDevelopmentStat.month)] = wealthDevelopmentStat;
    }
    double averageWealthGrowth = WealthDevelopmentStats.calculateAverageWealthGrowth(monthRevenues, monthExpenditures);
    // TODO hier weitermachen und dynamich machen 12 * 5 oder 12 * 10, etc.
    for (int i = DateTime.now().month; i < 12; i++) {
      WealthDevelopmentStats wealthDevelopmentStat = WealthDevelopmentStats();
      wealthDevelopmentStat.wealth = _assets - _liabilities;
      wealthDevelopmentStat.month = i.toString();
      wealthDevelopmentStat.wealth += averageWealthGrowth * i;
      wealthValues.add(wealthDevelopmentStat.wealth);
      _wealthDevelopmentStats[_wealthDevelopmentStats.indexWhere((element) => element.month == wealthDevelopmentStat.month)] = wealthDevelopmentStat;
    }
    _maxWealthValue = wealthValues.reduce(max);
    return _wealthDevelopmentStats;
  }

  LineChartBarData getLineChartData() {
    List<FlSpot> spotList = [];
    for (int i = 0; i < _wealthDevelopmentStats.length; i++) {
      spotList.add(FlSpot(i.toDouble(), double.parse((_wealthDevelopmentStats[i].wealth / 1000).toStringAsFixed(2))));
    }
    LineChartBarData lineChartBarData = LineChartBarData(
      spots: _getSpotList(spotList),
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 2.0,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
    return lineChartBarData;
  }

  List<FlSpot> _getSpotList(List<FlSpot> spotList) {
    for (int i = 0; i < spotList.length; i++) {
      spotList[i];
    }
    return spotList;
  }

  void _setSelectedAssetDevelopmentStatisticTab(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedAssetDevelopmentStatisticTabOption.length; i++) {
        _selectedAssetDevelopmentStatisticTabOption[i] = i == selectedIndex;
      }
      if (_selectedAssetDevelopmentStatisticTabOption[0]) {
        _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false];
      } else if (_selectedAssetDevelopmentStatisticTabOption[1]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, true, false, false];
      } else if (_selectedAssetDevelopmentStatisticTabOption[2]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, true, false];
      } else if (_selectedAssetDevelopmentStatisticTabOption[3]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, false, true];
      } else {
        _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ToggleButtons(
                onPressed: (selectedIndex) => _setSelectedAssetDevelopmentStatisticTab(selectedIndex),
                borderRadius: BorderRadius.circular(6.0),
                selectedBorderColor: Colors.cyanAccent,
                fillColor: Colors.cyanAccent.shade700,
                selectedColor: Colors.white,
                color: Colors.white60,
                constraints: const BoxConstraints(
                  minHeight: 30.0,
                  minWidth: 50.0,
                ),
                isSelected: _selectedAssetDevelopmentStatisticTabOption,
                children: const [
                  Text('1 J.'),
                  Text('5 J.'),
                  Text('10 J.'),
                  Text('40 J.'),
                ],
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: _loadChartBarData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.done:
                if (_wealthDevelopmentStats.isEmpty) {
                  return const Text('Noch keine Daten vorhanden.');
                } else {
                  return Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.7,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 18.0,
                            left: 12.0,
                            top: 24.0,
                            bottom: 12.0,
                          ),
                          child: LineChart(
                            showAvg ? avgData() : mainData(_wealthDevelopmentStats),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showAvg = !showAvg;
                            });
                          },
                          child: Text(
                            'avg',
                            style: TextStyle(
                              fontSize: 12,
                              color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              default:
                return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text('März\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
        break;
      case 5:
        text = Text('Juni\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
        break;
      case 8:
        text = Text('September\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
        break;
      default:
        text = const Text('', style: TextStyle(fontSize: 10));
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text = '';
    switch (value.toInt()) {
      case 1:
        text = '0 €';
        break;
      case 3:
        text = (_maxWealthValue / 2).toStringAsFixed(0) + ' €';
        break;
      case 5:
        text = _maxWealthValue.toStringAsFixed(0) + ' €';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<WealthDevelopmentStats> wealthDevelopmentStats) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1000,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white70,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white70,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0.0,
      maxX: 11.0, // TODO dynamich machen * 5,
      minY: 0.0,
      maxY: _maxWealthValue / 1000,
      lineBarsData: [
        getLineChartData(),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}