import 'package:bloc/bloc.dart';

part 'text_input_field_model.dart';

class TextInputFieldCubit extends Cubit<TextInputFieldModel> {
  TextInputFieldCubit() : super(TextInputFieldModel("", ""));
  void updateValue(String newValue) => emit(TextInputFieldModel(newValue, ""));
  void resetValue() => emit(TextInputFieldModel("", ""));
  bool checkValue(String value, String errorText) {
    if (value.isEmpty) {
      emit(TextInputFieldModel(value, errorText));
      return true;
    }
    return false;
  }
}
