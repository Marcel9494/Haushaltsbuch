part of 'booking_bloc.dart';

abstract class BookingEvents {}

class CreateBookingEvent extends BookingEvents {
  final BuildContext context;
  final Booking booking;
  CreateBookingEvent(this.context, this.booking);
}

class UpdateBookingEvent extends BookingEvents {
  final BuildContext context;
  final Booking oldBooking;
  final Booking updatedBooking;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;
  UpdateBookingEvent(this.context, this.oldBooking, this.updatedBooking, this.bookingBoxIndex, this.serieEditMode);
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
