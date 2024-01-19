import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '/models/enums/categorie_types.dart';

part 'categorie_type_toggle_buttons_model.dart';

class CategorieTypeToggleButtonsCubit extends Cubit<CategorieTypeToggleButtonsModel> {
  CategorieTypeToggleButtonsCubit() : super(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));

  void initCategorieType() {
    emit(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
  }

  void updateSelectedCategorieType(int selectedIndex, List<bool> selectedCategorieType, BuildContext context) {
    for (int i = 0; i < selectedCategorieType.length; i++) {
      selectedCategorieType[i] = i == selectedIndex;
    }
    if (selectedCategorieType[0]) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.income.name, [true, false, false], Colors.greenAccent, Colors.greenAccent.withOpacity(0.2)));
    } else if (selectedCategorieType[1]) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    } else if (selectedCategorieType[2]) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.investment.name, [false, false, true], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else {
      emit(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    }
  }

  void setCategorieType(String categorieType) {
    if (categorieType == CategorieType.income.name) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.income.name, [true, false, false], Colors.greenAccent, Colors.greenAccent.withOpacity(0.2)));
    } else if (categorieType == CategorieType.outcome.name) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    } else if (categorieType == CategorieType.investment.name) {
      emit(CategorieTypeToggleButtonsModel(CategorieType.investment.name, [false, false, true], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else {
      emit(CategorieTypeToggleButtonsModel(CategorieType.outcome.name, [false, true, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    }
  }
}
