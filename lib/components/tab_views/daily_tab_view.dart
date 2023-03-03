import 'package:flutter/material.dart';

import '/components/cards/booking_card.dart';

import '/models/booking.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late List<Booking> bookingList = [];

  Future<List<Booking>> loadBookingList() async {
    bookingList = await Booking.loadBookingList();
    return bookingList;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Täglich'),
          FutureBuilder(
            future: loadBookingList(),
            builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Warten');
                case ConnectionState.done:
                  if (bookingList.isEmpty) {
                    return const Text('Noch keine Buchungen vorhanden.');
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          bookingList = await loadBookingList();
                          setState(() {});
                          return;
                        },
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          itemCount: bookingList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BookingCard(booking: bookingList[index]);
                          },
                        ),
                      ),
                    );
                  }
                default:
                  return const Text('Warten');
              }
            },
          ),
        ],
      ),
    );
  }
}
