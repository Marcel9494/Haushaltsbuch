import 'package:bloc/bloc.dart';

import '/models/enums/repeat_types.dart';

part 'date_input_field_state.dart';

class DateInputFieldCubit extends Cubit<DateInputFieldModel> {
  DateInputFieldCubit() : super(DateInputFieldModel(DateTime.now().toString(), RepeatType.noRepetition.name));
  void updateBookingRepeat(String newBookingRepeat) => emit(DateInputFieldModel(state.bookingDate, newBookingRepeat));
  void updateBookingDate(String newBookingDate) => emit(DateInputFieldModel(newBookingDate, state.bookingRepeat));
  void resetValue() => emit(DateInputFieldModel(DateTime.now().toString(), RepeatType.noRepetition.name));
}
