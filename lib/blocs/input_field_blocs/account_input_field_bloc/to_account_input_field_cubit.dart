import 'package:bloc/bloc.dart';

part 'to_account_input_field_model.dart';

class ToAccountInputFieldCubit extends Cubit<ToAccountInputFieldModel> {
  ToAccountInputFieldCubit() : super(ToAccountInputFieldModel("", ""));
  void updateValue(String newValue) => emit(ToAccountInputFieldModel(newValue, ""));
  void resetValue() => emit(ToAccountInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(ToAccountInputFieldModel(value, "Bitte wählen Sie ein Konto aus."));
      return false;
    }
    return true;
  }
}
