import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buttons/month_picker_buttons.dart';

import '../input_fields/year_slider_input_field.dart';

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
  double _maxFutureWealthValue = 0.0;
  double _minFutureWealthValue = 0.0;
  double _currentYearPeriod = 1;
  List<WealthDevelopmentStats> _pastWealthDevelopmentStats = [];
  List<WealthDevelopmentStats> _futureWealthDevelopmentStats = [];
  List<WealthDevelopmentStats> _futureWealthWithCompoundInterestStats = [];
  //List<WealthDevelopmentStats> _investmentDevelopmentStats = [];
  List<double> monthRevenues = [];
  List<double> monthExpenditures = [];
  List<double> monthInvestments = [];
  List<double> wealthValues = [];
  List<double> _futureWealthValues = [];
  List<bool> _selectedAssetDevelopmentStatisticTabOption = [true, false, false, false, false, false];
  double _currentBalance = 0.0;
  double _years = 1;

  /*Future<List<WealthDevelopmentStats>> _loadChartBarData() async {
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
  }*/

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

  Future<List<WealthDevelopmentStats>> _calculateFutureWealthValues() {
    _calculateFutureWealthDevelopment();
    return _calculateFutureWealthWithCompoundInterest();
  }

  Future<List<WealthDevelopmentStats>> _calculateFutureWealthDevelopment() async {
    double averageWealthGrowth = 0.0;
    _futureWealthDevelopmentStats = [];
    for (int i = 0; i < 12 * _years; i++) {
      WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      futureWealthDevelopmentStat.month = i.toString();
      futureWealthDevelopmentStat.wealth = 1.0;
      _futureWealthDevelopmentStats.insert(i, futureWealthDevelopmentStat);
    }
    for (int i = 0; i < 12; i++) {
      //WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      //futureWealthDevelopmentStat.month = i.toString();
      //futureWealthDevelopmentStat.wealth = 1.0;
      //_futureWealthDevelopmentStats.insert(i, futureWealthDevelopmentStat);
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
      //monthInvestments.add(Booking.getInvestments(bookingList));
      averageWealthGrowth += Booking.getRevenues(bookingList) - Booking.getExpenditures(bookingList);
    }
    averageWealthGrowth /= 12;
    for (int i = 0; i < _futureWealthDevelopmentStats.length; i++) {
      _futureWealthDevelopmentStats[i].wealth = (averageWealthGrowth * i) + _currentBalance;
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
    double averageWealthGrowth = 0.0;
    _futureWealthWithCompoundInterestStats = [];
    for (int i = 0; i < 12 * _years; i++) {
      WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      futureWealthDevelopmentStat.month = i.toString();
      futureWealthDevelopmentStat.wealth = 1.0;
      _futureWealthWithCompoundInterestStats.insert(i, futureWealthDevelopmentStat);
    }
    for (int i = 0; i < 12; i++) {
      //WealthDevelopmentStats futureWealthDevelopmentStat = WealthDevelopmentStats();
      //futureWealthDevelopmentStat.month = i.toString();
      //futureWealthDevelopmentStat.wealth = 1.0;
      //_futureWealthDevelopmentStats.insert(i, futureWealthDevelopmentStat);
      int currentYear = _selectedDate.year;
      int currentMonth = _selectedDate.month - i;
      // Vergangenes Jahr z.B.: 2023 => 2022 & Januar => Dezember
      if (_selectedDate.month - i <= 0) {
        currentYear = _selectedDate.year - 1;
        currentMonth = _selectedDate.month + 12 - i;
      }
      List<Booking> bookingList = await Booking.loadMonthlyBookingList(currentMonth, currentYear);
      //monthInvestments.add(Booking.getInvestments(bookingList));
      averageWealthGrowth += Booking.getRevenues(bookingList) - Booking.getExpenditures(bookingList);
    }
    averageWealthGrowth /= 12;
    for (int i = 0; i < _futureWealthWithCompoundInterestStats.length; i++) {
      _futureWealthWithCompoundInterestStats[i].wealth = _currentBalance * math.pow((1 + 5 / 100), i - 1);
      //_futureWealthWithCompoundInterestStats[i].wealth = (averageWealthGrowth * i * 2) + _currentBalance;
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
    for (int i = 0; i < _futureWealthWithCompoundInterestStats.length; i = i + stepSize, spotX++) {
      spotList.add(FlSpot(spotX.toDouble(), double.parse((_futureWealthWithCompoundInterestStats[i].wealth / 1000).toStringAsFixed(2))));
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
          colors: investmentColors.map((color) => color.withOpacity(0.8)).toList(),
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
          Expanded(
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
          ),
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
        //getLineChartData(),
        //getInvestmentChartData(),
      ],
    );
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
      maxY: _maxFutureWealthValue / 1000,
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
