import 'package:bloc/bloc.dart';

class CategorieInputFieldCubit extends Cubit<String> {
  CategorieInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
