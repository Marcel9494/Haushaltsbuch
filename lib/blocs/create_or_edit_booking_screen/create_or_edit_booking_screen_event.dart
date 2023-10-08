part of 'create_or_edit_booking_screen_bloc.dart';

abstract class CreateOrEditBookingEvents {}

class CreateBookingEvent extends CreateOrEditBookingEvents {
  final BuildContext context;
  final Booking booking;
  CreateBookingEvent(this.context, this.booking);
}

class UpdateBookingEvent extends CreateOrEditBookingEvents {
  final BuildContext context;
  final Booking oldBooking;
  final Booking updatedBooking;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;
  UpdateBookingEvent(this.context, this.oldBooking, this.updatedBooking, this.bookingBoxIndex, this.serieEditMode);
}
