import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        if (event.newBooking.bookingRepeats == RepeatType.noRepetition.name) {
          bookingRepository.create(event.newBooking);
        } else {
          bookingRepository.createSerie(event.newBooking);
          GlobalStateRepository globalStateRepository = GlobalStateRepository();
          globalStateRepository.increaseBookingSerieIndex();
        }
        emit(CreateOrEditBookingSuccessState());
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
    });
  }
}
