import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buttons/month_picker_buttons.dart';

import '../charts/future_wealth_development_chart.dart';
import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/account.dart';
import '/models/booking.dart';
import '/models/wealth_development_stats.dart';

class AssetDevelopmentStatisticTabView extends StatefulWidget {
  const AssetDevelopmentStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetDevelopmentStatisticTabView> createState() => _AssetDevelopmentStatisticTabViewState();

  static _AssetDevelopmentStatisticTabViewState? of(BuildContext context) => context.findAncestorStateOfType<_AssetDevelopmentStatisticTabViewState>();
}

class _AssetDevelopmentStatisticTabViewState extends State<AssetDevelopmentStatisticTabView> {
  DateTime _selectedDate = DateTime.now();
  List<Color> revenueColors = [Colors.cyanAccent, Colors.cyan];
  List<Color> investmentColors = [Colors.greenAccent, Colors.green];
  double _assets = 0.0;
  double _liabilities = 0.0;
  double _maxWealthValue = 0.0;
  double _minWealthValue = 0.0;
  List<WealthDevelopmentStats> _pastWealthDevelopmentStats = [];
  List<double> monthRevenues = [];
  List<double> monthExpenditures = [];
  List<double> monthInvestments = [];
  List<double> wealthValues = [];
  double _currentBalance = 0.0;

  Future<List<WealthDevelopmentStats>> _calculatePastWealthDevelopment() async {
    _pastWealthDevelopmentStats = [];
    _assets = await Account.getAssetValue();
    _liabilities = await Account.getLiabilityValue();
    _currentBalance = _assets - _liabilities;
    for (int i = 0; i < 12; i++) {
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
      double revenues = Booking.getRevenues(bookingList);
      double expenditures = Booking.getExpenditures(bookingList);
      WealthDevelopmentStats pastWealthDevelopmentStat = WealthDevelopmentStats();
      pastWealthDevelopmentStat.month = currentMonth.toString();
      _currentBalance = _currentBalance + revenues - expenditures;
      pastWealthDevelopmentStat.wealth = _currentBalance;
      _pastWealthDevelopmentStats.insert(i, pastWealthDevelopmentStat);
      wealthValues.add(_pastWealthDevelopmentStats[i].wealth);
      _maxWealthValue = wealthValues.reduce(math.max);
      _minWealthValue = wealthValues.reduce(math.min);
    }
    return _pastWealthDevelopmentStats;
  }

  LineChartBarData _getPastWealthDevelopmentChartData() {
    List<FlSpot> spotList = [];
    for (int i = _pastWealthDevelopmentStats.length - 1; i >= 0; i--) {
      spotList.add(FlSpot(i.toDouble(), double.parse((_pastWealthDevelopmentStats[11 - i].wealth / 1000).toStringAsFixed(2))));
    }
    LineChartBarData lineChartBarData = LineChartBarData(
      spots: _getSpotList(spotList),
      gradient: LinearGradient(
        colors: revenueColors,
      ),
      barWidth: 2.0,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: revenueColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
    return lineChartBarData;
  }

  /*LineChartBarData getLineChartData() {
    List<FlSpot> spotList = [];
    for (int i = 0; i < _wealthDevelopmentStats.length; i++) {
      //print(_wealthDevelopmentStats[i].wealth);
      spotList.add(FlSpot(i.toDouble(), double.parse((_wealthDevelopmentStats[i].wealth / 1000).toStringAsFixed(2))));
    }
    LineChartBarData lineChartBarData = LineChartBarData(
      spots: _getSpotList(spotList),
      gradient: LinearGradient(
        colors: revenueColors,
      ),
      barWidth: 2.0,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: revenueColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
    return lineChartBarData;
  }

  LineChartBarData getInvestmentChartData() {
    List<FlSpot> spotList = [];
    for (int i = 0; i < _investmentDevelopmentStats.length; i++) {
      //print(_wealthDevelopmentStats[i].wealth);
      spotList.add(FlSpot(i.toDouble(), double.parse((_investmentDevelopmentStats[i].wealth / 1000).toStringAsFixed(2))));
    }
    LineChartBarData lineChartBarData = LineChartBarData(
      spots: _getSpotList(spotList),
      gradient: LinearGradient(
        colors: investmentColors,
      ),
      barWidth: 2.0,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: investmentColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
    return lineChartBarData;
  }*/

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: _calculatePastWealthDevelopment(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const SizedBox();
                case ConnectionState.done:
                  if (_pastWealthDevelopmentStats.isEmpty) {
                    return const Text('Noch keine Daten vorhanden.');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MonthPickerButtons(
                          selectedDate: _selectedDate,
                          selectedDateCallback: (DateTime selectedDate) {
                            setState(() {
                              _selectedDate = selectedDate;
                            });
                          },
                        ),
                        Stack(
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
                                  pastData(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                default:
                  return const SizedBox();
              }
            },
          ),
          const FutureWealthDevelopmentChart(),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_pastWealthDevelopmentStats[11].month)))}\n${_pastWealthDevelopmentStats[11].wealth.toStringAsFixed(2)}€',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10));
        break;
      case 5:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_pastWealthDevelopmentStats[5].month)))}\n${_pastWealthDevelopmentStats[5].wealth.toStringAsFixed(2)}€',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10));
        break;
      case 11:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_pastWealthDevelopmentStats[0].month)))}\n${_pastWealthDevelopmentStats[0].wealth.toStringAsFixed(2)}€',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10));
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

  List<FlSpot> _getSpotList(List<FlSpot> spotList) {
    for (int i = 0; i < spotList.length; i++) {
      spotList[i];
    }
    return spotList;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text = '';
    //print("Value " + value.toInt().floor().toString());
    //print("Max " + ((_maxWealthValue / 1000) / 2).floor().toString());
    if (value.toInt() == 0) {
      text = '0 €';
    } else if (value.toInt().floor() == (_maxWealthValue / 1000).floor()) {
      text = _maxWealthValue.toStringAsFixed(0) + ' €';
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData pastData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black45,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '${dateFormatterMMMM.format(DateTime(_selectedDate.year, int.parse(_pastWealthDevelopmentStats[barSpot.spotIndex].month)))}\n${formatToMoneyAmount((_pastWealthDevelopmentStats[barSpot.spotIndex].wealth).toString())}',
                const TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
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
      maxX: 11.0,
      minY: 0.0,
      maxY: _maxWealthValue / 1000,
      lineBarsData: [
        _getPastWealthDevelopmentChartData(),
      ],
    );
  }
}
