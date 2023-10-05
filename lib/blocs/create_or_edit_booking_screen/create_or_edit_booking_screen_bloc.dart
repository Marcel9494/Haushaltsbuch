import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/enums/transaction_types.dart';
import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_or_edit_booking_screen_event.dart';
part 'create_or_edit_booking_screen_state.dart';

class CreateOrEditBookingBloc extends Bloc<CreateOrEditBookingEvents, CreateOrEditBookingState> {
  BookingRepository bookingRepository = BookingRepository();

  CreateOrEditBookingBloc() : super(CreateOrEditBookingInitialState()) {
    on<CreateOrEditBookingEvents>((event, emit) async {
      print('Test 2');
      print(event);
      //if (event is CreateBookingEvent) {
      emit(CreateOrEditBookingLoadingState());
      try {
        print('Test 3');
        bookingRepository.create('Test Bloc', TransactionType.income.name, '2023-10-05 20:25:59.465092', 'None', '8.6', 'Bildung', '', 'Geldbeutel', 'Girokonto');
        emit(CreateOrEditBookingSuccessState());
      } catch (error) {
        emit(CreateOrEditBookingFailureState());
      }
      //}
    });
  }
}
