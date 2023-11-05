part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {
  final int bookingBoxIndex;
  BookingLoadingState(this.bookingBoxIndex);
}

class BookingSuccessState extends BookingState {
  BuildContext context;
  int bookingBoxIndex;
  BookingSuccessState(this.context, this.bookingBoxIndex);
}

class BookingFailureState extends BookingState {}

class BookingInitial extends BookingState {}
