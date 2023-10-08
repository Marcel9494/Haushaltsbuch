import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haushaltsbuch/models/enums/serie_edit_modes.dart';

import '/models/enums/repeat_types.dart';
import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';
import '/models/global_state/global_state_repository.dart';

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
        emit(CreateOrEditBookingSuccessState());
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });

    on<UpdateBookingEvent>((event, emit) async {
      emit(CreateOrEditBookingLoadingState());
      try {
        bookingRepository.update(event.updatedBooking, event.oldBooking, event.bookingBoxIndex, event.serieEditMode);
        emit(CreateOrEditBookingSuccessState());
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });
  }
}
