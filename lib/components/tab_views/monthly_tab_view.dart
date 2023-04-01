import 'package:flutter/material.dart';

import '/components/deco/loading_indicator.dart';
import '/components/cards/monthly_overview_card.dart';

import '../../models/booking.dart';

import '../deco/overview_tile.dart';

class MonthlyTabView extends StatefulWidget {
  const MonthlyTabView({Key? key}) : super(key: key);

  @override
  State<MonthlyTabView> createState() => _MonthlyTabViewState();
}

class _MonthlyTabViewState extends State<MonthlyTabView> {
  final List<Booking> _bookingList = [];

  Future<List<Booking>> _loadYearlyBookingList() async {
    return _bookingList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _loadYearlyBookingList(),
        builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingIndicator();
            case ConnectionState.done:
              if (_bookingList.isEmpty) {
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
                return Expanded(
                  child: ListView.builder(
                    itemCount: _bookingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return const MonthlyOverviewCard();
                    },
                  ),
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
