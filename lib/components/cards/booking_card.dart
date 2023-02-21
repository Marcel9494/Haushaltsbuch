import 'package:flutter/material.dart';

import '/models/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x0fffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.cyanAccent, width: 5)),
          ),
          child: Column(
            children: [
              Text(booking.title),
              Text(booking.categorie),
              Text(booking.amount),
              Text(booking.fromAccount),
              Text(booking.date.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
