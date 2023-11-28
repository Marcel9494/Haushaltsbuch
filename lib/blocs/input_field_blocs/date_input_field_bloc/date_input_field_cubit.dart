import 'package:bloc/bloc.dart';

import '/models/enums/repeat_types.dart';

part 'date_input_field_state.dart';

class DateInputFieldCubit extends Cubit<DateInputFieldState> {
  DateInputFieldCubit() : super(DateInputFieldState(DateTime.now().toString(), RepeatType.noRepetition.name));
  void updateBookingRepeat(String newBookingRepeat) => emit(DateInputFieldState(state.bookingDate, newBookingRepeat));
  void updateBookingDate(String newBookingDate) => emit(DateInputFieldState(newBookingDate, state.bookingRepeat));
  void resetValue() => emit(DateInputFieldState(DateTime.now().toString(), RepeatType.noRepetition.name));
}
