import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '/components/deco/loading_indicator.dart';
import '/components/cards/monthly_overview_card.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/booking.dart';
import '/models/monthly_stats.dart';

import '../deco/overview_tile.dart';

class MonthlyTabView extends StatefulWidget {
  const MonthlyTabView({Key? key}) : super(key: key);

  @override
  State<MonthlyTabView> createState() => _MonthlyTabViewState();
}

class _MonthlyTabViewState extends State<MonthlyTabView> {
  double _yearlyRevenues = 0.0;
  double _yearlyExpenditures = 0.0;
  double _yearlyInvestments = 0.0;
  DateTime _selectedDate = DateTime.now();
  List<MonthlyStats> _monthList = [];

  Future<List<MonthlyStats>> _loadMonthlyStatsList() async {
    _monthList.clear();
    for (int i = 0; i < 12; i++) {
      List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i + 1, _selectedDate.year);
      MonthlyStats monthlyStats = MonthlyStats();
      monthlyStats.month = dateFormatterMMMM.format(DateTime(_selectedDate.year, i + 1, 1)).toString();
      monthlyStats.revenues = Booking.getRevenues(_bookingList).toString();
      monthlyStats.expenditures = Booking.getExpenditures(_bookingList).toString();
      monthlyStats.investments = Booking.getInvestments(_bookingList).toString();
      _monthList.add(monthlyStats);
    }
    return _monthList;
  }

  double _getYearlyRevenues() {
    _yearlyRevenues = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyRevenues += formatMoneyAmountToDouble(_monthList[i].revenues);
    }
    return _yearlyRevenues;
  }

  double _getYearlyExpenditures() {
    _yearlyExpenditures = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyExpenditures += formatMoneyAmountToDouble(_monthList[i].expenditures);
    }
    return _yearlyExpenditures;
  }

  double _getYearlyInvestments() {
    _yearlyInvestments = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyInvestments += formatMoneyAmountToDouble(_monthList[i].investments);
    }
    return _yearlyInvestments;
  }

  void _nextYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month, _selectedDate.day);
    });
  }

  void _previousYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month, _selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left_rounded),
              onPressed: () => _previousYear(),
              padding: const EdgeInsets.only(left: 8.0, right: 2.0),
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
            ),
            SizedBox(
              width: 120.0,
              child: GestureDetector(
                onTap: () {
                  showMonthPicker(
                    context: context,
                    initialDate: _selectedDate,
                    headerColor: Colors.grey.shade800,
                    selectedMonthBackgroundColor: Colors.cyanAccent,
                    unselectedMonthTextColor: Colors.white,
                    confirmWidget: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
                    cancelWidget: const Text('Abbrechen', style: TextStyle(color: Colors.cyanAccent)),
                    locale: const Locale('DE-de'),
                    roundedCornersRadius: 12.0,
                    dismissible: true,
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        // TODO_selectedDate = date;
                      });
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(dateFormatterYYYY.format(_selectedDate), textAlign: TextAlign.center),
                ),
                behavior: HitTestBehavior.translucent,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onPressed: () => _nextYear(),
              padding: const EdgeInsets.only(left: 2.0),
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: _loadMonthlyStatsList(),
            builder: (BuildContext context, AsyncSnapshot<List<MonthlyStats>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingIndicator();
                case ConnectionState.done:
                  if (_monthList.isEmpty) {
                    return Column(
                      children: const [
                        OverviewTile(
                          shouldText: 'Einnahmen',
                          should: 0,
                          haveText: 'Ausgaben',
                          have: 0,
                          balanceText: 'Saldo',
                          showAverageValuesPerDay: true,
                          investmentText: 'Investitionen',
                          showInvestments: true,
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Noch keine Buchungen vorhanden.'),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        OverviewTile(
                          shouldText: 'Einnahmen',
                          should: _getYearlyRevenues(),
                          haveText: 'Ausgaben',
                          have: _getYearlyExpenditures(),
                          balanceText: 'Saldo',
                          showAverageValuesPerDay: true,
                          investmentText: 'Investitionen',
                          investmentAmount: _getYearlyInvestments(),
                          showInvestments: true,
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _monthList = await _loadMonthlyStatsList();
                              setState(() {});
                              return;
                            },
                            color: Colors.cyanAccent,
                            child: ListView.builder(
                              itemCount: _monthList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MonthlyOverviewCard(monthlyStats: _monthList[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                default:
                  return const Text('Warten');
              }
            },
          ),
        ),
      ],
    );
  }
}
