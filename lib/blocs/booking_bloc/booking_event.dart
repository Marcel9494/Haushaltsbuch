part of 'booking_bloc.dart';

abstract class BookingEvents {}

class CreateOrEditBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  CreateOrEditBookingEvent(this.context, this.bookingBoxIndex);
}

class CreateBookingEvent extends BookingEvents {
  final BuildContext context;
  CreateBookingEvent(this.context);
}

class UpdateBookingEvent extends BookingEvents {
  final BuildContext context;
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;
  UpdateBookingEvent(this.context, this.bookingBoxIndex, this.serieEditMode);
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
