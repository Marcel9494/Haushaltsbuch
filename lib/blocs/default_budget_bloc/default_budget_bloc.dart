import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/models/budget/budget_repository.dart';
import '/models/default_budget/default_budget_model.dart';
import '/models/default_budget/default_budget_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';

import '/utils/consts/global_consts.dart';
import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

part 'default_budget_event.dart';
part 'default_budget_state.dart';

class DefaultBudgetBloc extends Bloc<DefaultBudgetEvents, DefaultBudgetState> {
  BudgetRepository budgetRepository = BudgetRepository();
  DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();

  DefaultBudgetBloc() : super(DefaultBudgetInitial()) {
    on<LoadDefaultBudgetEvent>((event, emit) async {
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      DefaultBudget loadedDefaultBudget = await defaultBudgetRepository.load(event.budgetCategorie);
      categorieInputFieldCubit.updateValue(loadedDefaultBudget.categorie);
      moneyInputFieldCubit.updateValue(formatToMoneyAmount(loadedDefaultBudget.defaultBudget.toString()));

      Navigator.pushNamed(event.context, editDefaultBudgetRoute);
      emit(DefaultBudgetLoadedState(event.context, event.budgetCategorie));
    });

    on<UpdateDefaultBudgetEvent>((event, emit) async {
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      DefaultBudget loadedDefaultBudget = await defaultBudgetRepository.load(categorieInputFieldCubit.state.categorie);

      if (moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        DefaultBudget updatedDefaultBudget = DefaultBudget()
          ..index = loadedDefaultBudget.index
          ..categorie = categorieInputFieldCubit.state.categorie
          ..defaultBudget = formatMoneyAmountToDouble(moneyInputFieldCubit.state.amount);
        defaultBudgetRepository.update(updatedDefaultBudget);

        budgetRepository.updateAllBudgetsFromCategorie(updatedDefaultBudget);
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      // Damit die Budgets in der Budgetliste aktualisiert werden, wird der Bildschirm Stack abgebaut und neu aufgebaut.
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      Navigator.pushNamed(event.context, overviewBudgetsRoute);
    });
  }
}
