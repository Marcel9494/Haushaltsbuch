import 'package:bloc/bloc.dart';

part 'from_account_input_field_model.dart';

class FromAccountInputFieldCubit extends Cubit<FromAccountInputFieldModel> {
  FromAccountInputFieldCubit() : super(FromAccountInputFieldModel("", ""));
  void updateValue(String newValue) => emit(FromAccountInputFieldModel(newValue, ""));
  void resetValue() => emit(FromAccountInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(FromAccountInputFieldModel(value, "Bitte wählen Sie ein Konto aus."));
      return false;
    }
    return true;
  }
}
