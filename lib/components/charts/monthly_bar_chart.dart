import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/booking.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class MonthlyBarChart extends StatefulWidget {
  final List<Booking> bookingList;
  final Color leftBarColor = Colors.cyanAccent;
  final Color avgColor = Colors.cyan;

  const MonthlyBarChart({
    Key? key,
    required this.bookingList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MonthlyBarChartState();
}

class MonthlyBarChartState extends State<MonthlyBarChart> {
  List<Booking> _bookingList = [];
  List<double> _monthlyExpenditures = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<BarChartGroupData> _monthlyExpendituresBarGroups = [];
  List<BarChartGroupData> _reversedMonthlyExpendituresBarGroups = [];
  List<BarChartGroupData> _showingMonthlyExpendituresBarGroups = [];
  final double width = 8;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadMonthlyBarChartData();
  }

  Future<List<double>> _loadMonthlyBarChartData() async {
    _monthlyExpenditures = [];
    _monthlyExpendituresBarGroups = [];
    for (int i = 0; i < 7; i++) {
      _bookingList = await Booking.loadMonthlyBookingList(DateTime.now().month - i, DateTime.now().year, widget.bookingList[0].categorie);
      if (_bookingList.isEmpty) {
        _monthlyExpenditures.insert(i, 0.0);
        _monthlyExpendituresBarGroups.add(makeGroupData(i, _monthlyExpenditures[i]));
        continue;
      }
      _monthlyExpenditures.insert(i, Booking.getExpenditures(_bookingList, widget.bookingList[0].categorie));
      _monthlyExpendituresBarGroups.add(makeGroupData(i, _monthlyExpenditures[i]));
    }
    _reversedMonthlyExpendituresBarGroups = _monthlyExpendituresBarGroups.reversed.toList();
    setState(() {
      _showingMonthlyExpendituresBarGroups = _reversedMonthlyExpendituresBarGroups;
    });
    return _monthlyExpenditures;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.bookingList.isEmpty ? '' : 'Monatliche Buchungen für ' + widget.bookingList[0].categorie,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: _monthlyExpenditures.isEmpty ? 0.0 : _monthlyExpenditures.reduce(max),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) {
                        return BarTooltipItem(
                          formatToMoneyAmount((_monthlyExpenditures[a.x]).toString()),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                          return;
                        }
                        _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod in _showingMonthlyExpendituresBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum / _showingMonthlyExpendituresBarGroups[touchedGroupIndex].barRods.length;

                          _showingMonthlyExpendituresBarGroups[touchedGroupIndex] = _showingMonthlyExpendituresBarGroups[touchedGroupIndex].copyWith(
                            barRods: _showingMonthlyExpendituresBarGroups[touchedGroupIndex].barRods.map((rod) {
                              return rod.copyWith(toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
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
                        getTitlesWidget: bottomMonthTitles,
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _showingMonthlyExpendituresBarGroups,
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
    );
    String text = '';
    if (value == 0) {
      text = '0 €';
    } else if (value == _monthlyExpenditures.reduce(max) / 2) {
      text = formatToMoneyAmount((_monthlyExpenditures.reduce(max) / 2).toString());
    } else if (value == _monthlyExpenditures.reduce(max)) {
      text = formatToMoneyAmount(_monthlyExpenditures.reduce(max).toString());
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomMonthTitles(double value, TitleMeta meta) {
    final months = <String>[
      dateFormatterMMM.format(DateTime.now()),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 1)),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 2)),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 3)),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 4)),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 5)),
      dateFormatterMMM.format(DateTime(DateTime.now().year, DateTime.now().month - 6)),
    ];

    final Widget text = Text(
      months[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16.0,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
      ],
    );
  }
}
