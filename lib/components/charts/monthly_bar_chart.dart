import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/booking/booking_repository.dart';

import '/models/booking/booking_model.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class MonthlyBarChart extends StatefulWidget {
  final DateTime selectedDate;
  final String categorie;

  const MonthlyBarChart({
    Key? key,
    required this.selectedDate,
    this.categorie = '',
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
  int _touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadMonthlyBarChartData();
  }

  Future<List<double>> _loadMonthlyBarChartData() async {
    BookingRepository bookingRepository = BookingRepository();
    _monthlyExpenditures = [];
    _monthlyExpendituresBarGroups = [];
    _reversedMonthlyExpendituresBarGroups = [];
    _showingMonthlyExpendituresBarGroups = [];
    for (int i = 0; i < 7; i++) {
      int currentYear = widget.selectedDate.year;
      int currentMonth = widget.selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (widget.selectedDate.month - i <= 0) {
        currentYear = widget.selectedDate.year - 1;
        currentMonth = widget.selectedDate.month + 12 - i;
      }
      _bookingList = await bookingRepository.loadMonthlyBookingList(currentMonth, currentYear, widget.categorie);
      if (_bookingList.isEmpty) {
        _monthlyExpenditures.insert(i, 0.0);
        _monthlyExpendituresBarGroups.add(makeGroupData(i, _monthlyExpenditures[i]));
      } else {
        _monthlyExpenditures.insert(i, bookingRepository.getExpenditures(_bookingList, widget.categorie));
        _monthlyExpendituresBarGroups.add(makeGroupData(i, _monthlyExpenditures[i]));
      }
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
            const SizedBox(
              height: 14.0,
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
                          _touchedGroupIndex = -1;
                          _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                        });
                        return;
                      }

                      _touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          _touchedGroupIndex = -1;
                          _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                          return;
                        }
                        _showingMonthlyExpendituresBarGroups = List.of(_reversedMonthlyExpendituresBarGroups);
                        if (_touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod in _showingMonthlyExpendituresBarGroups[_touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum / _showingMonthlyExpendituresBarGroups[_touchedGroupIndex].barRods.length;
                          _showingMonthlyExpendituresBarGroups[_touchedGroupIndex] = _showingMonthlyExpendituresBarGroups[_touchedGroupIndex].copyWith(
                            barRods: _showingMonthlyExpendituresBarGroups[_touchedGroupIndex].barRods.map((rod) {
                              return rod.copyWith(toY: avg, color: Colors.cyan);
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
                        reservedSize: 32.0,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50.0,
                        interval: 1.0,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _showingMonthlyExpendituresBarGroups,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.cyanAccent.withOpacity(0.12),
                        strokeWidth: 0.8,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.cyanAccent.withOpacity(0.12),
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 0),
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
    } else if (value == (_monthlyExpenditures.reduce(max) / 2).round()) {
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
      dateFormatterMMM.format(widget.selectedDate),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 1)),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 2)),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 3)),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 4)),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 5)),
      dateFormatterMMM.format(DateTime(widget.selectedDate.year, widget.selectedDate.month - 6)),
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
          color: Colors.cyanAccent,
          width: 10.0,
        ),
      ],
    );
  }
}
