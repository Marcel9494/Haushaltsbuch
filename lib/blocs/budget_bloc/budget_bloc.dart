import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import '../../utils/consts/route_consts.dart';
import '/models/enums/budget_mode_types.dart';

import '../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/utils/consts/global_consts.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvents, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<SaveBudgetEvent>((event, emit) {
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      if (categorieInputFieldCubit.validateValue(categorieInputFieldCubit.state.categorie) == false ||
          moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        if (event.budgetModeType == BudgetModeType.budgetCreationMode) {
          if (subcategorieInputFieldCubit.state.isEmpty) {
            // TOOD hier weitermachen _createBudget();
          } else {
            // TODO _createSubbudget();
          }
        } else if (event.budgetModeType == BudgetModeType.updateDefaultBudgetMode) {
          // TODO _updateAllFutureBudgets();
        } else {
          // TODO _updateBudget();
        }
        // TODO if (_budgetExistsAlready == false) {
        event.saveButtonController.success();
        Timer(const Duration(milliseconds: transitionInMs), () {
          //if (mounted) {
          FocusScope.of(event.context).requestFocus(FocusNode());
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          if (event.budgetBoxIndex != -1) {
            Navigator.pop(event.context);
            Navigator.pop(event.context);
          }
          Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
          //}
        });
        //}
      }
    });
  }
}
