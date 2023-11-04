import 'package:bloc/bloc.dart';

class FromAccountInputFieldCubit extends Cubit<String> {
  FromAccountInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
