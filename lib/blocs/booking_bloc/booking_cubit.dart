import 'package:bloc/bloc.dart';

import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';

class BookingCubit extends Cubit<Map<Booking, int>> {
  BookingRepository bookingRepository = BookingRepository();
  BookingCubit() : super({Booking(): -1});

  void loadExistingBooking(int boxIndex) async {
    Booking booking = await bookingRepository.load(boxIndex);
    emit({booking: boxIndex});
  }
}
