import 'package:bloc/bloc.dart';

part 'text_input_field_model.dart';

class TextInputFieldCubit extends Cubit<TextInputFieldModel> {
  TextInputFieldCubit() : super(TextInputFieldModel("", ""));
  void updateValue(String newValue) => emit(TextInputFieldModel(newValue, ""));
  void resetValue() => emit(TextInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(TextInputFieldModel(value, "Bitte geben Sie einen Titel für die Buchung ein."));
      return false;
    }
    return true;
  }
}
