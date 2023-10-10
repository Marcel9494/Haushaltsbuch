import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/utils/consts/global_consts.dart';
import '/utils/consts/route_consts.dart';

import '/models/enums/repeat_types.dart';
import '/models/booking/booking_model.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/booking/booking_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_or_edit_booking_screen_event.dart';
part 'create_or_edit_booking_screen_state.dart';

class CreateOrEditBookingBloc extends Bloc<CreateOrEditBookingEvents, CreateOrEditBookingState> {
  BookingRepository bookingRepository = BookingRepository();

  CreateOrEditBookingBloc() : super(CreateOrEditBookingInitialState()) {
    on<CreateBookingEvent>((event, emit) async {
      emit(CreateOrEditBookingLoadingState());
      try {
        if (event.booking.bookingRepeats == RepeatType.noRepetition.name) {
          bookingRepository.create(event.booking);
        } else {
          bookingRepository.createSerie(event.booking);
          GlobalStateRepository globalStateRepository = GlobalStateRepository();
          globalStateRepository.increaseBookingSerieIndex();
        }
        emit(CreateOrEditBookingSuccessState(event.context));
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });

    on<UpdateBookingEvent>((event, emit) async {
      emit(CreateOrEditBookingLoadingState());
      try {
        bookingRepository.update(event.updatedBooking, event.oldBooking, event.bookingBoxIndex, event.serieEditMode);
        emit(CreateOrEditBookingSuccessState(event.context));
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });

    on<DeleteBookingEvent>((event, emit) async {
      void _yesPressed(int index) {
        if (event.serieEditMode == SerieEditModeType.none) {
          bookingRepository.delete(event.bookingBoxIndex);
        } else {
          Booking currentBooking = Booking()
            ..transactionType = event.booking.transactionType
            ..bookingRepeats = event.booking.bookingRepeats
            ..title = event.booking.title
            ..date = event.booking.date
            ..amount = event.booking.amount
            ..categorie = event.booking.categorie
            ..subcategorie = event.booking.subcategorie
            ..fromAccount = event.booking.fromAccount
            ..toAccount = event.booking.toAccount
            ..serieId = event.booking.serieId
            ..booked = event.booking.booked;
          bookingRepository.deleteSerieBookings(currentBooking, event.bookingBoxIndex, event.serieEditMode);
        }
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
        FocusScope.of(event.context).unfocus();
      }

      emit(CreateOrEditBookingLoadingState());
      try {
        showDialog(
          context: event.context,
          builder: (context) {
            return AlertDialog(
              title: Text(event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single ? 'Buchung löschen?' : 'Buchungen löschen?'),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Nein',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                    ),
                  ),
                  onPressed: () => {
                    Navigator.pop(context),
                    FocusScope.of(context).unfocus(),
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.cyanAccent,
                  ),
                  onPressed: () => {
                    _yesPressed(event.bookingBoxIndex),
                    Flushbar(
                      title:
                          event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single ? 'Buchung wurde gelöscht' : 'Buchungen wurden gelöscht',
                      message: event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single
                          ? 'Buchung wurde erfolgreich gelöscht.'
                          : 'Buchungen wurden erfolgreich gelöscht',
                      icon: const Icon(
                        Icons.info_outline,
                        size: 28.0,
                        color: Colors.cyanAccent,
                      ),
                      duration: const Duration(seconds: 3),
                      leftBarIndicatorColor: Colors.cyanAccent,
                    )..show(context),
                  },
                  child: const Text('Ja'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });
  }
}
