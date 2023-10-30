import 'package:bloc/bloc.dart';

class DateInputFieldCubit extends Cubit<String> {
  DateInputFieldCubit() : super(DateTime.now().toString());
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit(DateTime.now().toString());
}
