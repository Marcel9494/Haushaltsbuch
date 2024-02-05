import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/booking/booking_repository.dart';
import 'package:intl/intl.dart';

import '/models/booking/booking_model.dart';
import '/models/wealth_development_stats.dart';
import '/models/account/account_repository.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class FutureWealthDevelopmentChart extends StatefulWidget {
  const FutureWealthDevelopmentChart({Key? key}) : super(key: key);

  @override
  State<FutureWealthDevelopmentChart> createState() => _FutureWealthDevelopmentChartState();
}

class _FutureWealthDevelopmentChartState extends State<FutureWealthDevelopmentChart> {
  final DateTime _selectedDate = DateTime.now();
  double _years = 1;
  double _currentBalance = 0.0;
  double _averageWealthGrowth = 0.0;
  double _maxFutureWealthValue = 0.0;
  double _minFutureWealthValue = 0.0; // TODO
  List<Color> revenueColors = [Colors.cyanAccent, Colors.cyan];
  List<Color> investmentColors = [Colors.greenAccent, Colors.green];
  List<WealthDevelopmentStats> _futureWealthDevelopmentStats = [];
  List<WealthDevelopmentStats> _futureWealthWithCompoundInterestStats = [];
  List<bool> _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false, false, false];
  final List<double> _futureWealthValues = [];
  List<Booking> _bookingList = [];

  @override
  void initState() {
    super.initState();
    _calculateCurrentBalance();
    _loadBookingList();
  }

  void _calculateCurrentBalance() async {
    AccountRepository accountRepository = AccountRepository();
    _currentBalance = await accountRepository.getAssetValue() - await accountRepository.getLiabilityValue();
  }

  void _loadBookingList() async {
    BookingRepository bookingRepository = BookingRepository();
    for (int i = 0; i < 12; i++) {
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      _bookingList = await bookingRepository.loadMonthlyBookings(currentMonth, currentYear);
      _averageWealthGrowth += bookingRepository.getRevenues(_bookingList) - bookingRepository.getExpenditures(_bookingList);
    }
  }

  Future<List<WealthDevelopmentStats>> _calculateFutureWealthValues() {
    _calculateFutureWealthDevelopment();
    return _calculateFutureWealthWithCompoundInterest();
  }

  Future<List<WealthDevelopmentStats>> _calculateFutureWealthDevelopment() async {
    //double averageWealthGrowth = 0.0;
    _futureWealthDevelopmentStats = [];
    for (int i = 0; i < 12 * _years; i++) {
      WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      futureWealthDevelopmentStat.month = i.toString();
      futureWealthDevelopmentStat.wealth = 1.0;
      _futureWealthDevelopmentStats.insert(i, futureWealthDevelopmentStat);
    }
    /*for (int i = 0; i < 12; i++) {
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
      averageWealthGrowth += Booking.getRevenues(bookingList) - Booking.getExpenditures(bookingList);
    }*/
    _averageWealthGrowth /= 12;
    for (int i = 0; i < _futureWealthDevelopmentStats.length; i++) {
      _futureWealthDevelopmentStats[i].wealth = (_averageWealthGrowth * i) + _currentBalance;
      _futureWealthValues.add(_futureWealthDevelopmentStats[i].wealth);
      _maxFutureWealthValue = _futureWealthValues.reduce(math.max);
      _minFutureWealthValue = _futureWealthValues.reduce(math.min);
    }
    return _futureWealthDevelopmentStats;
  }

  LineChartBarData _getFutureWealthDevelopmentChartData() {
    List<FlSpot> spotList = [];
    int stepSize = _getStepSizeForFutureWealthValues();
    int spotX = 0;
    for (int i = 0; i < _futureWealthDevelopmentStats.length; i = i + stepSize, spotX++) {
      spotList.add(FlSpot(spotX.toDouble(), double.parse((_futureWealthDevelopmentStats[i].wealth / 1000).toStringAsFixed(2))));
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

  Future<List<WealthDevelopmentStats>> _calculateFutureWealthWithCompoundInterest() async {
    _futureWealthWithCompoundInterestStats = [];
    for (int i = 0; i < 12 * _years; i++) {
      WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      futureWealthDevelopmentStat.month = i.toString();
      futureWealthDevelopmentStat.wealth = 1.0;
      _futureWealthWithCompoundInterestStats.insert(i, futureWealthDevelopmentStat);
    }
    /*for (int i = 0; i < 12; i++) {
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
      // TODO monthInvestments.add(Booking.getInvestments(bookingList));
      averageWealthGrowth += Booking.getRevenues(bookingList) - Booking.getExpenditures(bookingList);
    }*/
    _averageWealthGrowth /= 12;
    for (int i = 0; i < _futureWealthWithCompoundInterestStats.length; i++) {
      _futureWealthWithCompoundInterestStats[i].wealth = _currentBalance * math.pow((1 + 5 / 100), i - 1);
      _futureWealthValues.add(_futureWealthWithCompoundInterestStats[i].wealth);
      _maxFutureWealthValue = _futureWealthValues.reduce(math.max);
      _minFutureWealthValue = _futureWealthValues.reduce(math.min);
    }
    return _futureWealthWithCompoundInterestStats;
  }

  LineChartBarData _getFutureWealthWithCompoundInterestChartData() {
    List<FlSpot> spotList = [];
    int stepSize = _getStepSizeForFutureWealthValues();
    int spotX = 0;
    double maxWealth = 0.0;
    for (int i = 0; i < _futureWealthWithCompoundInterestStats.length; i = i + stepSize) {
      if (_futureWealthWithCompoundInterestStats[i].wealth > maxWealth) {
        maxWealth = _futureWealthWithCompoundInterestStats[i].wealth;
      }
    }
    double onePercentValue = maxWealth / 100;
    for (int i = 0; i < _futureWealthWithCompoundInterestStats.length; i = i + stepSize, spotX++) {
      print("Wealth Stats: " + _futureWealthWithCompoundInterestStats[i].wealth.toString());
      print("Max: " + maxWealth.toString());
      double spotY = _futureWealthWithCompoundInterestStats[i].wealth / onePercentValue;
      spotList.add(FlSpot(spotX.toDouble(), double.parse((spotY).toStringAsFixed(2))));
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
        _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false, false, false];
        _years = 1;
      } else if (_selectedAssetDevelopmentStatisticTabOption[1]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, true, false, false, false, false];
        _years = 5;
      } else if (_selectedAssetDevelopmentStatisticTabOption[2]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, true, false, false, false];
        _years = 10;
      } else if (_selectedAssetDevelopmentStatisticTabOption[3]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, false, true, false, false];
        _years = 20;
      } else if (_selectedAssetDevelopmentStatisticTabOption[4]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, false, false, true, false];
        _years = 40;
      } else if (_selectedAssetDevelopmentStatisticTabOption[5]) {
        _selectedAssetDevelopmentStatisticTabOption = [false, false, false, false, false, true];
        _years = 50;
      } else {
        _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false, false, false];
        _years = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _calculateFutureWealthValues(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.done:
                if (_futureWealthDevelopmentStats.isEmpty) {
                  return const Text('Noch keine Daten vorhanden.');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Zukünftige Vermögensentwicklung:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
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
                            Text('20 J.'),
                            Text('40 J.'),
                            Text('50 J.'),
                          ],
                        ),
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
                                futureData(),
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
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_futureWealthDevelopmentStats[11].month)))}\n${_futureWealthDevelopmentStats[11].wealth.toStringAsFixed(2)}€',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10));
        break;
      case 5:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_futureWealthDevelopmentStats[5].month)))}\n${_futureWealthDevelopmentStats[5].wealth.toStringAsFixed(2)}€',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10));
        break;
      case 11:
        text = Text(
            '${DateFormat('MMMM', 'de-DE').format(DateTime(0, int.parse(_futureWealthDevelopmentStats[0].month)))}\n${_futureWealthDevelopmentStats[0].wealth.toStringAsFixed(2)}€',
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text = '';
    //print("Value " + value.toInt().floor().toString());
    //print("Max " + ((_maxWealthValue / 1000) / 2).floor().toString());
    if (value.toInt() == 0) {
      text = '0 €';
    } else if (value.toInt().floor() == (_maxFutureWealthValue / 1000).floor()) {
      text = _maxFutureWealthValue.toStringAsFixed(0) + ' €';
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData futureData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black45,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '${dateFormatterMMMM.format(DateTime(_selectedDate.year, int.parse(_futureWealthDevelopmentStats[barSpot.spotIndex].month)))}\n${formatToMoneyAmount((_futureWealthDevelopmentStats[barSpot.spotIndex].wealth).toString())}',
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
      maxX: _getMaxXForFutureWealthValues(),
      minY: 0.0,
      maxY: 100.0,
      lineBarsData: [
        _getFutureWealthDevelopmentChartData(),
        _getFutureWealthWithCompoundInterestChartData(),
      ],
    );
  }

  double _getMaxXForFutureWealthValues() {
    if (_years == 1) {
      return 11.0;
    } else if (_years == 5) {
      return 10.0;
    } else if (_years == 10) {
      return 10.0;
    } else if (_years == 20) {
      return 20.0;
    } else if (_years == 40) {
      return 20.0;
    } else if (_years == 50) {
      return 25.0;
    }
    return 11.0;
  }

  int _getStepSizeForFutureWealthValues() {
    if (_years == 1) {
      return 1;
    } else if (_years == 5) {
      return 6;
    } else if (_years == 10) {
      return 12;
    } else if (_years == 20) {
      return 12;
    } else if (_years == 40) {
      return 24;
    } else if (_years == 50) {
      return 24;
    }
    return 1;
  }
}
