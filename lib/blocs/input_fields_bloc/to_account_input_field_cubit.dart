import 'package:bloc/bloc.dart';

class ToAccountInputFieldCubit extends Cubit<String> {
  ToAccountInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
