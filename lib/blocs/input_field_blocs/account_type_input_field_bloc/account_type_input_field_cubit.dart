import 'package:bloc/bloc.dart';

part 'account_type_input_field_model.dart';

class AccountTypeInputFieldCubit extends Cubit<AccountTypeInputFieldModel> {
  AccountTypeInputFieldCubit() : super(AccountTypeInputFieldModel("", ""));
  void updateValue(String newValue) => emit(AccountTypeInputFieldModel(newValue, ""));
  void resetValue() => emit(AccountTypeInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(AccountTypeInputFieldModel(value, "Bitte wählen Sie ein Kontotyp aus."));
      return false;
    }
    return true;
  }
}
