import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/blocs/booking_bloc/booking_bloc.dart';

import '/models/booking/booking_model.dart';
import '/models/enums/repeat_types.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/create_or_edit_booking_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

import '../deco/bottom_sheet_line.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    Key? key,
    required this.booking,
  }) : super(key: key);

  Color _getTransactionTypeColor() {
    if (booking.booked == false) {
      return Colors.grey.shade600;
    } else if (booking.transactionType == TransactionType.income.name) {
      return Colors.greenAccent;
    } else if (booking.transactionType == TransactionType.outcome.name) {
      return const Color(0xfff4634f);
    } else if (booking.transactionType == TransactionType.transfer.name) {
      return Colors.cyanAccent;
    } else if (booking.transactionType == TransactionType.investment.name) {
      return Colors.cyanAccent;
    }
    return Colors.cyanAccent;
  }

  void _editBooking(BuildContext context) {
    if (booking.bookingRepeats == RepeatType.noRepetition.name) {
      BlocProvider.of<BookingBloc>(context).add(CreateOrLoadBookingEvent(context, booking.boxIndex));
    } else {
      showCupertinoModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Material(
            child: SizedBox(
              height: 244.0,
              child: ListView(
                children: [
                  const BottomSheetLine(),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 12.0, left: 20.0),
                    child: Text('Serienbuchung bearbeiten:', style: TextStyle(fontSize: 18.0)),
                  ),
                  Column(
                    children: [
                      ListTile(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, createOrEditBookingRoute, arguments: CreateOrEditBookingScreenArguments(booking.boxIndex, SerieEditModeType.single)),
                        leading: const Icon(Icons.looks_one_outlined, color: Colors.cyanAccent),
                        title: const Text('Nur diese Buchung'),
                      ),
                      ListTile(
                        onTap: () => Navigator.popAndPushNamed(context, createOrEditBookingRoute,
                            arguments: CreateOrEditBookingScreenArguments(booking.boxIndex, SerieEditModeType.onlyFuture)),
                        leading: const Icon(Icons.repeat_on_outlined, color: Colors.cyanAccent),
                        title: const Text('Alle zukünftige Buchungen'),
                      ),
                      ListTile(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, createOrEditBookingRoute, arguments: CreateOrEditBookingScreenArguments(booking.boxIndex, SerieEditModeType.all)),
                        leading: const Icon(Icons.all_inclusive_rounded, color: Colors.cyanAccent),
                        title: const Text('Alle Buchungen'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _editBooking(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: _getTransactionTypeColor(), width: 3.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name
                                ? const SizedBox()
                                : Text(booking.subcategorie.isEmpty ? booking.categorie : booking.subcategorie, overflow: TextOverflow.ellipsis),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name ? 0.0 : 8.0),
                              child: Text(booking.fromAccount, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                            ),
                            booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 16.0),
                                      Text(booking.toAccount, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(booking.title),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          booking.amount,
                          style: TextStyle(color: _getTransactionTypeColor()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
