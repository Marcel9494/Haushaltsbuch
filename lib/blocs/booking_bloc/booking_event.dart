part of 'booking_bloc.dart';

abstract class BookingEvents {}

class CreateOrLoadBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  CreateOrLoadBookingEvent(this.context, this.bookingBoxIndex);
}

class CreateOrUpdateBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  CreateOrUpdateBookingEvent(this.context, this.bookingBoxIndex);
}

class LoadBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  LoadBookingEvent(this.context, this.bookingBoxIndex);
}

class DeleteBookingEvent extends BookingEvents {
  final BuildContext context;
  final Booking booking;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;
  DeleteBookingEvent(this.context, this.booking, this.bookingBoxIndex, this.serieEditMode);
}
