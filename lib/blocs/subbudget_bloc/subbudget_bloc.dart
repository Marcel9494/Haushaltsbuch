import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/models/default_budget/default_budget_repository.dart';
import '/models/default_budget/default_budget_model.dart';
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
  DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();

  SubbudgetBloc() : super(SubbudgetInitial()) {
    on<CreateSubbudgetEvent>((event, emit) async {
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
      event.saveButtonController.success();
      Timer(const Duration(milliseconds: transitionInMs), () {
        FocusScope.of(event.context).requestFocus(FocusNode());
        Navigator.pop(event.context);
        Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      });
    });

    on<LoadSubbudgetListFromOneCategorieEvent>((event, emit) async {
      emit(SubbudgetLoadingState());
      DefaultBudget defaultBudget = await defaultBudgetRepository.load(event.categorie);
      List<Subbudget> subbudgetList = await subbudgetRepository.loadSubbudgetListFromOneCategorie(event.categorie, event.selectedYear);

      if (event.subbudgetBoxIndex >= 0) {
        SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
        MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
        Subbudget loadedSubbudget = await subbudgetRepository.load(event.subbudgetBoxIndex);
        subcategorieInputFieldCubit.updateValue(loadedSubbudget.subcategorieName);
        moneyInputFieldCubit.updateAmount(formatToMoneyAmount(loadedSubbudget.subcategorieBudget.toString()));
        if (event.pushNewScreen) {
          Navigator.pushNamed(event.context, editSubbudgetRoute);
        }
      } else {
        if (event.pushNewScreen) {
          Navigator.pushNamed(event.context, overviewOneSubbudgetRoute);
        }
      }
      emit(SubbudgetLoadedState(event.context, event.subbudgetBoxIndex, subbudgetList, defaultBudget, event.categorie, event.selectedYear));
    });

    on<UpdateSubbudgetEvent>((event, emit) async {
      SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      Subbudget loadedSubbudget = await subbudgetRepository.load(event.subbudgetBoxIndex);

      if (moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        Subbudget updatedSubbudget = Subbudget()
          ..categorie = loadedSubbudget.categorie
          ..subcategorieName = subcategorieInputFieldCubit.state
          ..subcategorieBudget = formatMoneyAmountToDouble(moneyInputFieldCubit.state.amount)
          ..currentSubcategorieExpenditure = 0.0
          ..currentSubcategoriePercentage = 0.0
          ..budgetDate = loadedSubbudget.budgetDate;
        subbudgetRepository.update(updatedSubbudget, event.subbudgetBoxIndex);
      }
      event.saveButtonController.success();
      DefaultBudget defaultBudget = await defaultBudgetRepository.load(subcategorieInputFieldCubit.state);
      List<Subbudget> subbudgetList =
          await subbudgetRepository.loadSubbudgetListFromOneCategorie(subcategorieInputFieldCubit.state, DateTime.parse(loadedSubbudget.budgetDate).year);
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, overviewOneSubbudgetRoute);
      emit(SubbudgetLoadedState(
          event.context, event.subbudgetBoxIndex, subbudgetList, defaultBudget, subcategorieInputFieldCubit.state, DateTime.parse(loadedSubbudget.budgetDate).year));
    });

    on<DeleteSubbudgetEvent>((event, emit) async {
      subbudgetRepository.deleteAllBudgetsFromCategorie(event.subbudgetCategorie);
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
