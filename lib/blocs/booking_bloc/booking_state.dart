part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {}

class BookingSuccessState extends BookingState {
  BuildContext context;
  int boxIndex;
  Booking booking;
  BookingSuccessState(this.context, this.boxIndex, this.booking);
}

class BookingFailureState extends BookingState {}

class BookingInitial extends BookingState {}
