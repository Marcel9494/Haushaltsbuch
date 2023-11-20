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
  final String errorText;
  final SerieEditModeType serieEditModeType;
  final Function saveButtonController;
  BookingSuccessState(this.context, this.bookingBoxIndex, this.errorText, this.serieEditModeType, this.saveButtonController);
}

class CreateOrUpdateFailureState extends BookingState {
  CreateOrUpdateFailureState();
}

class BookingFailureState extends BookingState {
  BookingFailureState();
}

class BookingInitial extends BookingState {}
