import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/account.dart';
import '/models/booking.dart';
import '/models/wealth_development_stats.dart';

class AssetDevelopmentStatisticTabView extends StatefulWidget {
  const AssetDevelopmentStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetDevelopmentStatisticTabView> createState() => _AssetDevelopmentStatisticTabViewState();
}

class _AssetDevelopmentStatisticTabViewState extends State<AssetDevelopmentStatisticTabView> {
  List<Color> revenueColors = [Colors.cyanAccent, Colors.cyan];
  List<Color> investmentColors = [Colors.greenAccent, Colors.green];
  bool showAvg = false;
  bool _showSaldoLine = true;
  bool _showInvestmentLine = true;
  double _assets = 0.0;
  double _liabilities = 0.0;
  double _maxWealthValue = 0.0;
  double _minWealthValue = 0.0;
  double _currentYearPeriod = 1;
  List<WealthDevelopmentStats> _pastWealthDevelopmentStats = [];
  List<WealthDevelopmentStats> _wealthDevelopmentStats = [];
  List<WealthDevelopmentStats> _investmentDevelopmentStats = [];
  List<double> monthRevenues = [];
  List<double> monthExpenditures = [];
  List<double> monthInvestments = [];
  List<double> wealthValues = [];
  List<bool> _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false];
  double _currentBalance = 0.0;

  Future<List<WealthDevelopmentStats>> _loadChartBarData() async {
    _wealthDevelopmentStats = [];
    _assets = await Account.getAssetValue();
    _liabilities = await Account.getLiabilityValue();
    List<double> wealthValues = [];
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

  Future<List<WealthDevelopmentStats>> _calculatePastAssetDevelopment() async {
    for (int i = 0; i < 12; i++) {
      WealthDevelopmentStats wealthDevelopmentStat = WealthDevelopmentStats();
      wealthDevelopmentStat.month = DateTime(DateTime.now().year, i).toString();
      wealthDevelopmentStat.wealth = 0.0;
      _wealthDevelopmentStats.add(wealthDevelopmentStat);
    }
    _assets = await Account.getAssetValue();
    _liabilities = await Account.getLiabilityValue();
    _currentBalance = _assets - _liabilities;
    // TODO hier weitermachen und alle Werte currentBalance, monthExpenditures, monthRevenues & monthInvestments anzeigen lassen
    // und currentBalance richtig berechnen.
    for (int i = DateTime.now().month - 1; i >= 0; i--) {
      //print(dateFormatterMMMM.format(i));
      if (i == DateTime.now().month - 1) {
        _wealthDevelopmentStats[i].month = i.toString();
        _wealthDevelopmentStats[i].wealth = _currentBalance;
        wealthValues.add(_wealthDevelopmentStats[i].wealth);
      } else {
        List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i, DateTime.now().year);
        double monthExpenditures = Booking.getExpenditures(_bookingList);
        double monthRevenues = Booking.getRevenues(_bookingList);
        //double monthInvestments = Booking.getInvestments(_bookingList);
        //print("Revenues" + monthRevenues.toString());
        _currentBalance = _currentBalance - (monthRevenues - monthExpenditures);
        _wealthDevelopmentStats[i].month = i.toString();
        _wealthDevelopmentStats[i].wealth = _currentBalance;
        //print(_wealthDevelopmentStats[i - 1].wealth);
        wealthValues.add(_wealthDevelopmentStats[i].wealth);
      }
      _maxWealthValue = wealthValues.reduce(max);
      _minWealthValue = wealthValues.reduce(min);
    }
    _calculateFutureAssetDevelopment();
    _calculateFutureInvestmentDevelopment();
    _calculatePastWealthDevelopment();
    return _wealthDevelopmentStats;
  }

  void _calculateFutureAssetDevelopment() async {
    monthRevenues = [];
    monthExpenditures = [];
    for (int i = DateTime.now().month; i >= 0; i--) {
      List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i, DateTime.now().year);
      monthRevenues.add(Booking.getRevenues(_bookingList));
      monthExpenditures.add(Booking.getExpenditures(_bookingList));
      //_wealthDevelopmentStats[i].month = i.toString();
      //_wealthDevelopmentStats[i].wealth = monthWealth;
      //print(_wealthDevelopmentStats[i].wealth);
      //wealthValues.add(_wealthDevelopmentStats[i].wealth);
      //_maxWealthValue = wealthValues.reduce(max);
    }
    double averageWealthGrowth = WealthDevelopmentStats.calculateAverageWealthGrowth(monthRevenues, monthExpenditures);
    print(averageWealthGrowth);
    for (int i = DateTime.now().month; i < 12; i++) {
      _currentBalance += averageWealthGrowth;
      _wealthDevelopmentStats[i].month = i.toString();
      _wealthDevelopmentStats[i].wealth = _currentBalance;
      wealthValues.add(_wealthDevelopmentStats[i].wealth);
      _maxWealthValue = wealthValues.reduce(max);
      _minWealthValue = wealthValues.reduce(min);
    }
  }

  void _calculateFutureInvestmentDevelopment() async {
    monthRevenues = [];
    monthExpenditures = [];
    for (int i = 0; i < 12; i++) {
      WealthDevelopmentStats investmentDevelopmentStat = WealthDevelopmentStats();
      investmentDevelopmentStat.month = DateTime(DateTime.now().year, i).toString();
      investmentDevelopmentStat.wealth = 0.0;
      _investmentDevelopmentStats.add(investmentDevelopmentStat);
    }
    for (int i = DateTime.now().month; i >= 0; i--) {
      List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i, DateTime.now().year);
      monthRevenues.add(Booking.getRevenues(_bookingList));
      monthExpenditures.add(Booking.getExpenditures(_bookingList));
      monthInvestments.add(Booking.getInvestments(_bookingList));
      //_wealthDevelopmentStats[i].month = i.toString();
      //_wealthDevelopmentStats[i].wealth = monthWealth;
      //print(_wealthDevelopmentStats[i].wealth);
      //wealthValues.add(_wealthDevelopmentStats[i].wealth);
      //_maxWealthValue = wealthValues.reduce(max);
    }
    double averageInvestmentGrowth = WealthDevelopmentStats.calculateAverageInvestmentGrowth(monthRevenues, monthExpenditures, monthInvestments);
    for (int i = 0 /*DateTime.now().month*/; i < 12; i++) {
      //_currentBalance += averageInvestmentGrowth;
      _investmentDevelopmentStats[i].month = i.toString();
      _investmentDevelopmentStats[i].wealth = WealthDevelopmentStats.calculateCompoundInterest(_currentBalance, i);
      wealthValues.add(_investmentDevelopmentStats[i].wealth);
      _maxWealthValue = wealthValues.reduce(max);
      _minWealthValue = wealthValues.reduce(min);
    }
  }

  Future<List<WealthDevelopmentStats>> _calculatePastWealthDevelopment() async {
    _assets = await Account.getAssetValue();
    _liabilities = await Account.getLiabilityValue();
    _currentBalance = _assets - _liabilities;
    for (int i = 0; i < 12; i++) {
      if (i == 0) {
        WealthDevelopmentStats pastWealthDevelopmentStat = WealthDevelopmentStats();
        pastWealthDevelopmentStat.month = DateTime.now().month.toString();
        pastWealthDevelopmentStat.wealth = _currentBalance;
        _pastWealthDevelopmentStats.add(pastWealthDevelopmentStat);
      } else {
        int currentYear = DateTime.now().year;
        int currentMonth = DateTime.now().month - i;
        // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
        if (DateTime.now().month - i <= 0) {
          currentYear = DateTime.now().year - 1;
          currentMonth = DateTime.now().month + 12 - i;
        }
        List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
        double revenues = Booking.getRevenues(bookingList);
        double expenditures = Booking.getExpenditures(bookingList);
        double investments = Booking.getInvestments(bookingList);
        // TODO hier weitermachen und vergangene Vermögensentwicklung weiter implementieren
        _currentBalance = _currentBalance + revenues - expenditures;
        WealthDevelopmentStats pastWealthDevelopmentStat = WealthDevelopmentStats();
        pastWealthDevelopmentStat.month = DateTime.now().month.toString();
        pastWealthDevelopmentStat.wealth = _currentBalance;
        print(_currentBalance);
        _pastWealthDevelopmentStats.add(pastWealthDevelopmentStat);
        wealthValues.add(_wealthDevelopmentStats[i].wealth);
        _maxWealthValue = wealthValues.reduce(max);
        _minWealthValue = wealthValues.reduce(min);
      }
    }
    //_pastWealthDevelopmentStats.reversed;
    return _pastWealthDevelopmentStats;
  }

  LineChartBarData getPastWealthDevelopmentChartData() {
    List<FlSpot> spotList = [];
    for (int i = 0; i < _pastWealthDevelopmentStats.length; i++) {
      spotList.add(FlSpot(i.toDouble(), double.parse((_pastWealthDevelopmentStats[i].wealth / 1000).toStringAsFixed(2))));
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

  LineChartBarData getLineChartData() {
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
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Saldo'),
                value: _showSaldoLine,
                onChanged: (value) {
                  setState(() {
                    _showSaldoLine = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Mit Investitionen'),
                value: _showInvestmentLine,
                onChanged: (value) {
                  setState(() {
                    _showInvestmentLine = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: _calculatePastAssetDevelopment(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.done:
                if (_wealthDevelopmentStats.isEmpty) {
                  return const Text('Noch keine Daten vorhanden.');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Text('40 J.'),
                          ],
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
      case 0:
        text = Text('Januar\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
        break;
      case 5:
        text = Text('Juni\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
        break;
      case 11:
        text = Text('Dezember\n${_wealthDevelopmentStats[value.toInt()].wealth.toStringAsFixed(2)}€', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10));
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
    } else if (value.toInt().floor() == (_maxWealthValue / 1000).floor()) {
      text = _maxWealthValue.toStringAsFixed(0) + ' €';
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<WealthDevelopmentStats> wealthDevelopmentStats) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black45,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '${dateFormatterMMMM.format(DateTime(DateTime.now().year, int.parse(_wealthDevelopmentStats[barSpot.spotIndex].month) + 1))}\n${formatToMoneyAmount((barSpot.y * 1000).toString())}',
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
      maxX: 11.0, // TODO dynamich machen * 5,
      minY: 0.0,
      maxY: _maxWealthValue / 1000,
      lineBarsData: [
        getPastWealthDevelopmentChartData(),
        //getLineChartData(),
        //getInvestmentChartData(),
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
              ColorTween(begin: revenueColors[0], end: revenueColors[1]).lerp(0.2)!,
              ColorTween(begin: revenueColors[0], end: revenueColors[1]).lerp(0.2)!,
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
                ColorTween(begin: revenueColors[0], end: revenueColors[1]).lerp(0.2)!.withOpacity(0.1),
                ColorTween(begin: revenueColors[0], end: revenueColors[1]).lerp(0.2)!.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
