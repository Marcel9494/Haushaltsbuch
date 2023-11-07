import 'package:bloc/bloc.dart';

class TextInputFieldCubit extends Cubit<String> {
  TextInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
  bool checkValue(String value) {
    if (value.isEmpty) {
      emit("Test");
      return false;
    }
    return true;
  }
}
