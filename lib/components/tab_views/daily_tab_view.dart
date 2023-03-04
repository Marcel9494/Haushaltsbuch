import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/enums/transaction_types.dart';

import '/components/deco/overview_tile.dart';
import '/components/cards/booking_card.dart';

import '/utils/number_formatters/number_formatter.dart';

import '/models/booking.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late List<Booking> _bookingList = [];
  late double _revenues = 0.0;
  late double _expenditures = 0.0;

  Future<List<Booking>> loadBookingList() async {
    _bookingList = await Booking.loadBookingList();
    return _bookingList;
  }

  double _getRevenues() {
    _revenues = 0.0;
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.income.name) {
        _revenues += formatMoneyAmountToDouble(_bookingList[i].amount);
      }
    }
    return _revenues;
  }

  double _getExpenditures() {
    _expenditures = 0.0;
    for (int i = 0; i < _bookingList.length; i++) {
      if (_bookingList[i].transactionType == TransactionType.outcome.name) {
        _expenditures += formatMoneyAmountToDouble(_bookingList[i].amount);
      }
    }
    return _expenditures;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: loadBookingList(),
        builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Warten');
            case ConnectionState.done:
              if (_bookingList.isEmpty) {
                return const Text('Noch keine Buchungen vorhanden.');
              } else {
                return Column(
                  children: [
                    OverviewTile(shouldText: 'Einnahmen', should: _getRevenues(), haveText: 'Ausgaben', have: _getExpenditures(), balanceText: 'Saldo'),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _bookingList = await loadBookingList();
                          setState(() {});
                          return;
                        },
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          itemCount: _bookingList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BookingCard(booking: _bookingList[index]);
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
