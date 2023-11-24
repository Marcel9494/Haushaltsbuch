part of 'booking_bloc.dart';

abstract class BookingEvents {}

class CreateOrLoadBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditModeType;
  CreateOrLoadBookingEvent(this.context, this.bookingBoxIndex, this.serieEditModeType);
}

class CreateOrUpdateBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditModeType;
  final RoundedLoadingButtonController saveButtonController;
  CreateOrUpdateBookingEvent(this.context, this.bookingBoxIndex, this.serieEditModeType, this.saveButtonController);
}

class DeleteBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;
  DeleteBookingEvent(this.context, this.bookingBoxIndex, this.serieEditMode);
}
