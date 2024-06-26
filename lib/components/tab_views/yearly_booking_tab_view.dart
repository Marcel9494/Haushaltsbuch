import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../utils/consts/global_consts.dart';
import '/models/monthly_stats.dart';
import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';

import '/utils/date_formatters/date_formatter.dart';

import '../cards/monthly_overview_card.dart';

import '../deco/loading_indicator.dart';
import '../deco/overview_tile.dart';

class YearlyBookingTabView extends StatefulWidget {
  final DateTime selectedDate;

  const YearlyBookingTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<YearlyBookingTabView> createState() => _YearlyBookingTabViewState();
}

class _YearlyBookingTabViewState extends State<YearlyBookingTabView> {
  double _yearlyRevenues = 0.0;
  double _yearlyExpenditures = 0.0;
  double _yearlyInvestments = 0.0;
  List<MonthlyStats> _monthList = [];

  Future<List<MonthlyStats>> _loadMonthlyStatsList() async {
    BookingRepository bookingRepository = BookingRepository();
    _monthList.clear();
    for (int i = 0; i < 12; i++) {
      List<Booking> _bookingList = await bookingRepository.loadMonthlyBookings(i + 1, widget.selectedDate.year);
      MonthlyStats monthlyStats = MonthlyStats();
      monthlyStats.month = dateFormatterMMMM.format(DateTime(widget.selectedDate.year, i + 1, 1)).toString();
      monthlyStats.revenues = bookingRepository.getRevenues(_bookingList);
      monthlyStats.expenditures = bookingRepository.getExpenditures(_bookingList);
      monthlyStats.investments = bookingRepository.getInvestments(_bookingList);
      _monthList.add(monthlyStats);
    }
    return _monthList;
  }

  double _getYearlyRevenues() {
    _yearlyRevenues = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyRevenues += _monthList[i].revenues;
    }
    return _yearlyRevenues;
  }

  double _getYearlyExpenditures() {
    _yearlyExpenditures = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyExpenditures += _monthList[i].expenditures;
    }
    return _yearlyExpenditures;
  }

  double _getYearlyInvestments() {
    _yearlyInvestments = 0.0;
    for (int i = 0; i < _monthList.length; i++) {
      _yearlyInvestments += _monthList[i].investments;
    }
    return _yearlyInvestments;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadMonthlyStatsList(),
      builder: (BuildContext context, AsyncSnapshot<List<MonthlyStats>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_monthList.isEmpty) {
              return Column(
                children: [
                  const OverviewTile(
                    shouldText: 'Einnahmen',
                    should: 0.0,
                    haveText: 'Ausgaben',
                    have: 0.0,
                    balanceText: 'Saldo',
                    investmentText: 'Investitionen',
                    availableText: 'Verfügbar',
                    showInvestments: true,
                    showAvailable: true,
                  ).animate().fade(duration: fadeAnimationInMs.ms),
                  const Expanded(
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
                    investmentText: 'Investitionen',
                    availableText: 'Verfügbar',
                    investmentAmount: _getYearlyInvestments(),
                    showInvestments: true,
                    showAvailable: true,
                  ).animate().fade(duration: fadeAnimationInMs.ms),
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
                          return MonthlyOverviewCard(monthlyStats: _monthList[index], selectedYear: widget.selectedDate.year);
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
    );
  }
}
