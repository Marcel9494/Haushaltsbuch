import 'package:bloc/bloc.dart';

part 'categorie_input_field_model.dart';

class CategorieInputFieldCubit extends Cubit<CategorieInputFieldModel> {
  CategorieInputFieldCubit() : super(CategorieInputFieldModel("", ""));
  void updateValue(String newValue) => emit(CategorieInputFieldModel(newValue, ""));
  void resetValue() => emit(CategorieInputFieldModel("", ""));
  bool validateValue(String value) {
    if (value.isEmpty) {
      emit(CategorieInputFieldModel(value, "Bitte wählen Sie eine Kategorie aus."));
      return false;
    }
    return true;
  }
}
