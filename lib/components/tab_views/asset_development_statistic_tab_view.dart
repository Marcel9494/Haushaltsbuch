import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';

import '/components/buttons/month_picker_buttons.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class AssetDevelopmentStatisticTabView extends StatefulWidget {
  const AssetDevelopmentStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetDevelopmentStatisticTabView> createState() => _AssetDevelopmentStatisticTabViewState();
}

class _AssetDevelopmentStatisticTabViewState extends State<AssetDevelopmentStatisticTabView> {
  final double width = 7.0;
  DateTime _selectedDate = DateTime.now();
  List<Booking> _bookingList = [];
  List<double> _monthlyValues = [];
  List<double> _monthlyRevenues = [];
  List<double> _monthlyExpenditures = [];
  List<BarChartGroupData> _monthlyBarGroups = [];
  List<BarChartGroupData> _reversedMonthlyBarGroups = [];
  List<BarChartGroupData> _showingMonthlyBarGroups = [];

  List<Color> gradientColors = [
    Colors.cyanAccent,
    Colors.blueAccent,
  ];

  @override
  void initState() {
    super.initState();
    _loadMonthlyBarChartData();
  }

  Future<List<double>> _loadMonthlyBarChartData() async {
    BookingRepository bookingRepository = BookingRepository();
    _monthlyRevenues = [];
    _monthlyExpenditures = [];
    _monthlyValues = [];
    _monthlyBarGroups = [];
    _reversedMonthlyBarGroups = [];
    _showingMonthlyBarGroups = [];
    for (int i = 0; i < 6; i++) {
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      _bookingList = await bookingRepository.loadMonthlyBookings(currentMonth, currentYear);
      if (_bookingList.isEmpty) {
        _monthlyRevenues.insert(i, 0.0);
        _monthlyExpenditures.insert(i, 0.0);
        _monthlyValues.insert(i, 0.0);
        _monthlyValues.insert(i + 1, 0.0);
        _monthlyBarGroups.add(makeGroupData(i, _monthlyValues[i], _monthlyValues[i + 1]));
      } else {
        _monthlyRevenues.insert(i, bookingRepository.getRevenues(_bookingList));
        _monthlyExpenditures.insert(i, bookingRepository.getExpenditures(_bookingList));
        _monthlyValues.insert(i, bookingRepository.getRevenues(_bookingList));
        _monthlyValues.insert(i + 1, bookingRepository.getExpenditures(_bookingList));
        _monthlyBarGroups.add(makeGroupData(i, _monthlyValues[i], _monthlyValues[i + 1]));
      }
    }
    _reversedMonthlyBarGroups = _monthlyBarGroups.reversed.toList();
    setState(() {
      _showingMonthlyBarGroups = _reversedMonthlyBarGroups;
    });
    return _monthlyValues;
  }

  void _changeStartMonth(DateTime selectedDate) {
    setState(() => {
          _selectedDate = selectedDate,
        });
    _loadMonthlyBarChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: ListView(
          children: <Widget>[
            MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => _changeStartMonth(selectedDate)),
            const SizedBox(
              height: 18.0,
            ),
            AspectRatio(
              aspectRatio: 1.75,
              child: BarChart(
                BarChartData(
                  maxY: _monthlyValues.isEmpty ? 0.0 : _monthlyValues.reduce(max),
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
                        reservedSize: 70.0,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 54.0,
                        interval: 1.0,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _showingMonthlyBarGroups,
                  gridData: FlGridData(show: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 0),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            const Text('Vermögensentwicklung'),
            AspectRatio(
              aspectRatio: 1.75,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18.0,
                  left: 12.0,
                  top: 24.0,
                  bottom: 12.0,
                ),
                child: LineChart(
                  assetDevelopmentData(),
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
    } else if (value == (_monthlyValues.reduce(max) / 2).round()) {
      text = formatToMoneyAmountWithoutCent((_monthlyValues.reduce(max) / 2).toString());
    } else if (value == _monthlyValues.reduce(max)) {
      text = formatToMoneyAmountWithoutCent(_monthlyValues.reduce(max).toString());
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0.0,
      child: Text(text, style: style),
    );
  }

  Widget bottomMonthTitles(double value, TitleMeta meta) {
    final months = <String>[
      dateFormatterMMM.format(_selectedDate),
      dateFormatterMMM.format(DateTime(_selectedDate.year, _selectedDate.month - 1)),
      dateFormatterMMM.format(DateTime(_selectedDate.year, _selectedDate.month - 2)),
      dateFormatterMMM.format(DateTime(_selectedDate.year, _selectedDate.month - 3)),
      dateFormatterMMM.format(DateTime(_selectedDate.year, _selectedDate.month - 4)),
      dateFormatterMMM.format(DateTime(_selectedDate.year, _selectedDate.month - 5)),
    ];

    final Widget text = Text(
      '${months[value.toInt()]}\n${formatToMoneyAmountWithoutCent(_monthlyRevenues[value.toInt()].toString())}\n${formatToMoneyAmountWithoutCent(_monthlyExpenditures[value.toInt()].toString())}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 11.0,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16.0, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4.0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.greenAccent,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.redAccent,
          width: width,
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData assetDevelopmentData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.cyanAccent,
            strokeWidth: 1.0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.cyanAccent,
            strokeWidth: 1.0,
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
            reservedSize: 30,
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
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
