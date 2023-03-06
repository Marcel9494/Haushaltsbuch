import 'package:flutter/material.dart';

import '/components/buttons/change_month_buttons.dart';
import '/components/deco/overview_tile.dart';
import '/components/cards/booking_card.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/booking.dart';
import '/models/enums/transaction_types.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late List<Booking> _bookingList = [];
  late double _revenues = 0.0;
  late double _expenditures = 0.0;
  late List<double> _todayExpenditures = [];

  Future<List<Booking>> loadBookingList() async {
    _bookingList = await Booking.loadBookingList();
    _getTodayExpenditures(_bookingList);
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

  double _getTodayExpenditures(List<Booking> bookingList) {
    _todayExpenditures = [];
    for (int i = 1; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.outcome.name) {
        if (bookingList[i].date != bookingList[i - 1].date) {
          _todayExpenditures.add(formatMoneyAmountToDouble(bookingList[i].amount));
        } else {
          // TODO hier weitermachen
          _todayExpenditures += formatMoneyAmountToDouble(bookingList[i].amount);
        }
      }
    }
    return _todayExpenditures;
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
                    const ChangeMonthButtons(),
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
                            DateTime previousBookingDate = DateTime(0, 0, 0);
                            DateTime bookingDate = DateTime(0, 0, 0);
                            if (index != 0) {
                              previousBookingDate = DateTime(DateTime.parse(_bookingList[index - 1].date).year, DateTime.parse(_bookingList[index - 1].date).month,
                                  DateTime.parse(_bookingList[index - 1].date).day);
                              bookingDate = DateTime(
                                  DateTime.parse(_bookingList[index].date).year, DateTime.parse(_bookingList[index].date).month, DateTime.parse(_bookingList[index].date).day);
                            }
                            if (index == 0 || previousBookingDate != bookingDate) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(dateFormatterDDMMYYYYEE.format(DateTime.parse(_bookingList[index].date)) + ':', style: const TextStyle(fontSize: 16.0)),
                                      ),
                                      const Text('Einnahmen'),
                                      const Text('Ausgaben'),
                                    ],
                                  ),
                                  BookingCard(booking: _bookingList[index]),
                                ],
                              );
                            } else if (previousBookingDate == bookingDate) {
                              return BookingCard(booking: _bookingList[index]);
                            }
                            return const SizedBox();
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
