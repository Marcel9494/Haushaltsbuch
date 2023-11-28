import 'package:bloc/bloc.dart';

part 'money_input_field_model.dart';

class MoneyInputFieldCubit extends Cubit<MoneyInputFieldModel> {
  MoneyInputFieldCubit() : super(MoneyInputFieldModel("", ""));
  void updateValue(String newValue) => emit(MoneyInputFieldModel(newValue, ""));
  void resetValue() => emit(MoneyInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(MoneyInputFieldModel(value, "Bitte geben Sie einen Betrag ein."));
      return false;
    }
    return true;
  }
}
