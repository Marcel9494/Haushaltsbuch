part of 'create_or_edit_booking_screen_bloc.dart';

abstract class CreateOrEditBookingState {}

class CreateOrEditBookingInitialState extends CreateOrEditBookingState {}

class CreateOrEditBookingLoadingState extends CreateOrEditBookingState {}

class CreateOrEditBookingSuccessState extends CreateOrEditBookingState {
  CreateOrEditBookingSuccessState();
}

class CreateOrEditBookingFailureState extends CreateOrEditBookingState {}
