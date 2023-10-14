import 'package:bloc/bloc.dart';

class TextInputFieldCubit extends Cubit<String> {
  TextInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
