import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '/components/cards/booking_card.dart';
import '/components/deco/overview_tile.dart';
import '/components/deco/loading_indicator.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/booking.dart';
import '/models/enums/transaction_types.dart';

import '../deco/date_text.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late List<Booking> _bookingList = [];
  late DateTime _selectedDate = DateTime.now();
  late double _revenues = 0.0;
  late double _expenditures = 0.0;
  late final Map<DateTime, double> _todayExpendituresMap = {};
  late final Map<DateTime, double> _todayRevenuesMap = {};

  Future<List<Booking>> loadMonthlyBookingList() async {
    _bookingList = await Booking.loadMonthlyBookingList(_selectedDate.month, _selectedDate.year);
    _prepareMaps(_bookingList);
    _getTodayExpenditures(_bookingList);
    _getTodayRevenues(_bookingList);
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

  void _prepareMaps(List<Booking> bookingList) {
    _todayExpendituresMap.clear();
    _todayRevenuesMap.clear();
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.outcome.name || bookingList[i].transactionType == TransactionType.income.name) {
        DateTime bookingDate = DateTime(DateTime.parse(bookingList[i].date).year, DateTime.parse(bookingList[i].date).month, DateTime.parse(bookingList[i].date).day);
        if (_todayExpendituresMap.containsKey(bookingDate) == false && _todayRevenuesMap.containsKey(bookingDate) == false) {
          _todayExpendituresMap[bookingDate] = 0.0;
          _todayRevenuesMap[bookingDate] = 0.0;
        }
      }
    }
  }

  void _getTodayExpenditures(List<Booking> bookingList) {
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.outcome.name) {
        DateTime bookingDate = DateTime(DateTime.parse(bookingList[i].date).year, DateTime.parse(bookingList[i].date).month, DateTime.parse(bookingList[i].date).day);
        double? amount = _todayExpendituresMap[bookingDate];
        amount = amount! + formatMoneyAmountToDouble(bookingList[i].amount);
        _todayExpendituresMap[bookingDate] = amount;
      }
    }
  }

  void _getTodayRevenues(List<Booking> bookingList) {
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.income.name) {
        DateTime bookingDate = DateTime(DateTime.parse(bookingList[i].date).year, DateTime.parse(bookingList[i].date).month, DateTime.parse(bookingList[i].date).day);
        double? amount = _todayRevenuesMap[bookingDate];
        amount = amount! + formatMoneyAmountToDouble(bookingList[i].amount);
        _todayRevenuesMap[bookingDate] = amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
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
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  });
                },
                child: Text(dateFormatterMMMMYYYY.format(_selectedDate))),
          ),
          Expanded(
            child: FutureBuilder(
              future: loadMonthlyBookingList(),
              builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingIndicator();
                  case ConnectionState.done:
                    if (_bookingList.isEmpty) {
                      return Column(
                        children: const [
                          OverviewTile(shouldText: 'Einnahmen', should: 0, haveText: 'Ausgaben', have: 0, balanceText: 'Saldo'),
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
                          OverviewTile(shouldText: 'Einnahmen', should: _getRevenues(), haveText: 'Ausgaben', have: _getExpenditures(), balanceText: 'Saldo'),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                _bookingList = await loadMonthlyBookingList();
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
                                    bookingDate = DateTime(DateTime.parse(_bookingList[index].date).year, DateTime.parse(_bookingList[index].date).month,
                                        DateTime.parse(_bookingList[index].date).day);
                                  }
                                  if (index == 0 || previousBookingDate != bookingDate) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            DateText(dateString: _bookingList[index].date),
                                            Text(
                                                formatToMoneyAmount(_todayRevenuesMap[DateTime(DateTime.parse(_bookingList[index].date).year,
                                                        DateTime.parse(_bookingList[index].date).month, DateTime.parse(_bookingList[index].date).day)]
                                                    .toString()),
                                                style: const TextStyle(color: Colors.greenAccent)),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 21.0),
                                              child: Text(
                                                  formatToMoneyAmount(_todayExpendituresMap[DateTime(DateTime.parse(_bookingList[index].date).year,
                                                          DateTime.parse(_bookingList[index].date).month, DateTime.parse(_bookingList[index].date).day)]
                                                      .toString()),
                                                  style: const TextStyle(color: Color(0xfff4634f))),
                                            ),
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
          ),
        ],
      ),
    );
  }
}
