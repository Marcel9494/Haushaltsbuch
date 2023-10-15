import 'package:bloc/bloc.dart';

class SubcategorieInputFieldCubit extends Cubit<String> {
  SubcategorieInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
