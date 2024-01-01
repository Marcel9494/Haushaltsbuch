import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/models/budget/budget_model.dart';
import '/models/budget/budget_repository.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

part 'subbudget_event.dart';
part 'subbudget_state.dart';

class SubbudgetBloc extends Bloc<SubbudgetEvent, SubbudgetState> {
  BudgetRepository budgetRepository = BudgetRepository();
  SubbudgetRepository subbudgetRepository = SubbudgetRepository();

  SubbudgetBloc() : super(SubbudgetInitial()) {
    on<SaveSubbudgetEvent>((event, emit) async {
      CategorieInputFieldCubit categorie = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      SubcategorieInputFieldCubit subcategorie = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit budgetAmount = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      if (categorie.validateValue(categorie.state.categorie) == false || budgetAmount.validateValue(budgetAmount.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        if (await budgetRepository.existsBudgetForCategorie(categorie.state.categorie) == false) {
          Budget newBudget = Budget()
            ..categorie = categorie.state.categorie
            ..budget = formatMoneyAmountToDouble(budgetAmount.state.amount)
            ..currentExpenditure = 0.0
            ..percentage = 0.0
            ..budgetDate = DateTime.now().toString();
          budgetRepository.create(newBudget);
        }
        Subbudget newSubbudget = Subbudget()
          ..categorie = categorie.state.categorie
          ..subcategorieName = subcategorie.state
          ..subcategorieBudget = formatMoneyAmountToDouble(budgetAmount.state.amount)
          ..currentSubcategorieExpenditure = 0.0
          ..currentSubcategoriePercentage = 0.0
          ..budgetDate = DateTime.now().toString();
        subbudgetRepository.create(newSubbudget);
      }
      // TODO if (_budgetExistsAlready == false) {
      event.saveButtonController.success();
      Timer(const Duration(milliseconds: transitionInMs), () {
        FocusScope.of(event.context).requestFocus(FocusNode());
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        if (event.subbudgetBoxIndex != -1) {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
        }
        Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      });
    });

    // TODO hier weitermachen und Subbudgets erstellen / bearbeiten implementieren extra Bloc für Subbudgets erstellen?!
    on<LoadSubbudgetEvent>((event, emit) async {
      emit(SubbudgetLoadingState());
      CategorieInputFieldCubit categorie = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      SubcategorieInputFieldCubit subcategorie = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit budgetAmount = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      Budget updatedBudget = Budget()
        ..categorie = categorie.state.categorie
        ..budget = formatMoneyAmountToDouble(budgetAmount.state.amount)
        ..currentExpenditure = 0.0
        ..percentage = 0.0
        ..budgetDate = DateTime.now().toString();
      // TODO subbudgetRepository.update(updatedBudget, event.budgetBoxIndex);

      /*if (event.budgetModeType == BudgetModeType.updateDefaultBudgetMode) {
          // TODO _updateAllFutureBudgets();
        } else {
          // TODO _updateBudget();
        }*/

      emit(SubbudgetLoadedState());
    });
  }
}
