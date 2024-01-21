import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../components/dialogs/choice_dialog.dart';
import '/models/default_budget/default_budget_model.dart';
import '/models/default_budget/default_budget_repository.dart';
import '/models/budget/budget_model.dart';
import '/models/budget/budget_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvents, BudgetState> {
  BudgetRepository budgetRepository = BudgetRepository();
  DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();

  BudgetBloc() : super(BudgetInitial()) {
    on<InitializeBudgetEvent>((event, emit) {
      emit(BudgetInitializingState());
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      categorieInputFieldCubit.resetValue();
      subcategorieInputFieldCubit.resetValue();
      moneyInputFieldCubit.resetValue();

      Navigator.pushNamed(event.context, createBudgetRoute);
      emit(BudgetInitializedState());
    });

    on<CreateBudgetEvent>((event, emit) {
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      if (categorieInputFieldCubit.validateValue(categorieInputFieldCubit.state.categorie) == false ||
          moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        Budget newBudget = Budget()
          ..categorie = categorieInputFieldCubit.state.categorie
          ..budget = formatMoneyAmountToDouble(moneyInputFieldCubit.state.amount)
          ..currentExpenditure = 0.0
          ..percentage = 0.0
          ..budgetDate = DateTime.now().toString();
        budgetRepository.create(newBudget);
      }
      event.saveButtonController.success();
      Timer(const Duration(milliseconds: transitionInMs), () {
        FocusScope.of(event.context).requestFocus(FocusNode());
        Navigator.pop(event.context);
        Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      });
    });

    // TODO kann eventuell noch verbessert / vereinfacht werden
    on<LoadBudgetListFromOneCategorieEvent>((event, emit) async {
      emit(BudgetLoadingState());
      DefaultBudget defaultBudget = await defaultBudgetRepository.load(event.categorie);
      List<Budget> budgetList = await budgetRepository.loadBudgetListFromOneCategorie(event.categorie, event.selectedYear);

      if (event.budgetBoxIndex >= 0) {
        CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
        MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
        Budget loadedBudget = await budgetRepository.load(event.budgetBoxIndex);
        categorieInputFieldCubit.updateValue(loadedBudget.categorie);
        moneyInputFieldCubit.updateValue(formatToMoneyAmount(loadedBudget.budget.toString()));
        if (event.pushNewScreen) {
          Navigator.pushNamed(event.context, editBudgetRoute);
        }
      } else {
        if (event.pushNewScreen) {
          Navigator.pushNamed(event.context, overviewOneBudgetRoute);
        }
      }
      emit(BudgetLoadedState(event.context, event.budgetBoxIndex, budgetList, defaultBudget, event.categorie, event.selectedYear));
    });

    on<UpdateBudgetEvent>((event, emit) async {
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      Budget loadedBudget = await budgetRepository.load(event.budgetBoxIndex);

      if (categorieInputFieldCubit.validateValue(categorieInputFieldCubit.state.categorie) == false ||
          moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        Budget updatedBudget = Budget()
          ..categorie = categorieInputFieldCubit.state.categorie
          ..budget = formatMoneyAmountToDouble(moneyInputFieldCubit.state.amount)
          ..currentExpenditure = 0.0
          ..percentage = 0.0
          ..budgetDate = loadedBudget.budgetDate;
        budgetRepository.update(updatedBudget, event.budgetBoxIndex);
      }
      event.saveButtonController.success();
      DefaultBudget defaultBudget = await defaultBudgetRepository.load(categorieInputFieldCubit.state.categorie);
      List<Budget> budgetList = await budgetRepository.loadBudgetListFromOneCategorie(categorieInputFieldCubit.state.categorie, DateTime.parse(loadedBudget.budgetDate).year);
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, overviewOneBudgetRoute);
      emit(BudgetLoadedState(
          event.context, event.budgetBoxIndex, budgetList, defaultBudget, categorieInputFieldCubit.state.categorie, DateTime.parse(loadedBudget.budgetDate).year));
    });

    on<DeleteBudgetEvent>((event, emit) async {
      budgetRepository.deleteAllBudgetsFromCategorie(event.budgetCategorie);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
        Navigator.pushNamed(event.context, overviewBudgetsRoute);
      });
    });
  }
}
