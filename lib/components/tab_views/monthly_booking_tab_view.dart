import 'package:flutter/material.dart';

import '../deco/total_text.dart';
import '/models/booking.dart';
import '/models/enums/transaction_types.dart';

import '../buttons/month_picker_buttons.dart';

import '../cards/booking_card.dart';

import '/utils/number_formatters/number_formatter.dart';

import '../charts/monthly_bar_chart.dart';

import '../deco/date_text.dart';
import '../deco/loading_indicator.dart';
import '../deco/overview_tile.dart';

class MonthlyBookingTabView extends StatefulWidget {
  final DateTime selectedDate;
  final String categorie;
  final String account;
  final bool showOverviewTile;
  final bool showBarChart;

  const MonthlyBookingTabView({
    Key? key,
    required this.selectedDate,
    required this.categorie,
    required this.account,
    this.showOverviewTile = true,
    this.showBarChart = false,
  }) : super(key: key);

  @override
  State<MonthlyBookingTabView> createState() => _MonthlyBookingTabViewState();
}

class _MonthlyBookingTabViewState extends State<MonthlyBookingTabView> {
  late List<Booking> _bookingList = [];
  late DateTime _selectedDate = widget.selectedDate;
  late final Map<DateTime, double> _todayExpendituresMap = {};
  late final Map<DateTime, double> _todayRevenuesMap = {};

  Future<List<Booking>> _loadMonthlyBookingList() async {
    _bookingList = await Booking.loadMonthlyBookingList(_selectedDate.month, _selectedDate.year, widget.categorie, widget.account);
    _prepareMaps(_bookingList);
    _getTodayExpenditures(_bookingList);
    _getTodayRevenues(_bookingList);
    return _bookingList;
  }

  void _prepareMaps(List<Booking> bookingList) {
    _todayExpendituresMap.clear();
    _todayRevenuesMap.clear();
    for (int i = 0; i < bookingList.length; i++) {
      DateTime bookingDate = DateTime(DateTime.parse(bookingList[i].date).year, DateTime.parse(bookingList[i].date).month, DateTime.parse(bookingList[i].date).day);
      if (_todayExpendituresMap.containsKey(bookingDate) == false && _todayRevenuesMap.containsKey(bookingDate) == false) {
        _todayExpendituresMap[bookingDate] = 0.0;
        _todayRevenuesMap[bookingDate] = 0.0;
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
    return Expanded(
      child: FutureBuilder(
        future: _loadMonthlyBookingList(),
        builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingIndicator();
            case ConnectionState.done:
              if (_bookingList.isEmpty) {
                return Column(
                  children: [
                    widget.showOverviewTile
                        ? const OverviewTile(
                            shouldText: 'Einnahmen',
                            should: 0,
                            haveText: 'Ausgaben',
                            have: 0,
                            balanceText: 'Saldo',
                            showAverageValuesPerDay: true,
                            investmentText: 'Investitionen',
                            showInvestments: true,
                          )
                        : const SizedBox(),
                    widget.showBarChart
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: MonthPickerButtons(
                                  selectedDate: _selectedDate,
                                  selectedDateCallback: (DateTime selectedDate) {
                                    setState(() {
                                      _selectedDate = selectedDate;
                                    });
                                  },
                                ),
                              ),
                              const TotalText(total: '0,0 €'),
                            ],
                          )
                        : const SizedBox(),
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
                    widget.showOverviewTile
                        ? OverviewTile(
                            shouldText: 'Einnahmen',
                            should: Booking.getRevenues(_bookingList),
                            haveText: 'Ausgaben',
                            have: Booking.getExpenditures(_bookingList),
                            balanceText: 'Saldo',
                            showAverageValuesPerDay: true,
                            investmentText: 'Investitionen',
                            investmentAmount: Booking.getInvestments(_bookingList),
                            showInvestments: true,
                          )
                        : const SizedBox(),
                    widget.showBarChart
                        ? Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: MonthPickerButtons(
                                      selectedDate: _selectedDate,
                                      selectedDateCallback: (DateTime selectedDate) {
                                        setState(() {
                                          _selectedDate = selectedDate;
                                        });
                                      },
                                    ),
                                  ),
                                  TotalText(total: formatToMoneyAmount(Booking.getExpenditures(_bookingList, _bookingList[0].categorie).toString())),
                                ],
                              ),
                              MonthlyBarChart(selectedDate: _selectedDate, categorie: _bookingList[0].categorie),
                            ],
                          )
                        : const SizedBox(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _bookingList = await _loadMonthlyBookingList();
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
                                  Padding(
                                    padding: EdgeInsets.only(top: index == 0 ? 0.0 : 10.0),
                                    child: Row(
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
