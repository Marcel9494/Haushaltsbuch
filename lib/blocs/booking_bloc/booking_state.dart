part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {
  BookingLoadingState();
}

class BookingLoadedState extends BookingState {
  final BuildContext context;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditModeType;
  BookingLoadedState(this.context, this.bookingBoxIndex, this.serieEditModeType);
}
