part of 'create_or_edit_booking_screen_bloc.dart';

abstract class CreateOrEditBookingEvents {}

class CreateBookingEvent extends CreateOrEditBookingEvents {
  final BuildContext context;
  final Booking newBooking;
  CreateBookingEvent(this.context, this.newBooking);
}
