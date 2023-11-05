part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {
  final int bookingBoxIndex;
  BookingLoadingState(this.bookingBoxIndex);
}

class BookingSuccessState extends BookingState {
  final BuildContext context;
  final int bookingBoxIndex;
  BookingSuccessState(this.context, this.bookingBoxIndex);
}

class BookingFailureState extends BookingState {
  final String errorText;
  BookingFailureState(this.errorText);
}

class BookingInitial extends BookingState {}
