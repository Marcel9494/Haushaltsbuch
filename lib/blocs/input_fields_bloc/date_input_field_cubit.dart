import 'package:bloc/bloc.dart';

import '/utils/date_formatters/date_formatter.dart';

class DateInputFieldCubit extends Cubit<String> {
  DateInputFieldCubit() : super(dateFormatterDDMMYYYY.format(DateTime.now()));
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit(dateFormatterDDMMYYYY.format(DateTime.now()));
}
