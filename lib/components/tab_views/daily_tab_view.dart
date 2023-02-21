import 'package:flutter/material.dart';

import '/components/cards/booking_card.dart';

import '/models/booking.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late Booking booking;

  Future<Booking> loadBookings() async {
    booking = await Booking.loadBooking();
    return booking;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Täglich'),
          FutureBuilder(
            future: loadBookings(),
            builder: (BuildContext context, AsyncSnapshot<Booking> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Waiting');
                default:
                  return BookingCard(booking: booking);
              }
            },
          ),
        ],
      ),
    );
  }
}
