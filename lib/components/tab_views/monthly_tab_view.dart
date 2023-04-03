import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/number_formatters/number_formatter.dart';
import '/components/deco/loading_indicator.dart';
import '/components/cards/monthly_overview_card.dart';

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
  List<MonthlyStats> _monthList = [];
  final DateTime _selectedDate = DateTime.now();

  Future<List<MonthlyStats>> _loadMonthlyStatsList() async {
    _monthList.clear();
    for (int i = 0; i < 12; i++) {
      List<Booking> _bookingList = await Booking.loadMonthlyBookingList(i + 1, _selectedDate.year);
      MonthlyStats monthlyStats = MonthlyStats();
      monthlyStats.month = DateFormat('MMMM', 'de-DE').format(DateTime(_selectedDate.year, i + 1, 1)).toString();
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
