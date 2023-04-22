import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/utils/number_formatters/number_formatter.dart';
import '/utils/consts/route_consts.dart';

import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/budget.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateOrEditBudgetScreen extends StatefulWidget {
  const CreateOrEditBudgetScreen({
    Key? key,
    required int budgetBoxIndex,
  }) : super(key: key);

  @override
  State<CreateOrEditBudgetScreen> createState() => _CreateOrEditBudgetScreenState();
}

class _CreateOrEditBudgetScreenState extends State<CreateOrEditBudgetScreen> {
  final TextEditingController _categorieTextController = TextEditingController();
  final TextEditingController _budgetTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  String _categorieErrorText = '';
  String _budgetErrorText = '';

  void _createOrUpdateBudget() {
    Budget budget = Budget()
      ..categorie = _categorieTextController.text
      ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
      ..currentAmount = 0.0
      ..percentage = 0.0;
    budget.createBudget(budget);
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      }
    });
  }

  void _setSaveButtonAnimation(bool successful) {
    successful ? _saveButtonController.success() : _saveButtonController.error();
    if (successful == false) {
      Timer(const Duration(seconds: 1), () {
        _saveButtonController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0x00ffffff),
        appBar: AppBar(
          title: const Text('Budget erstellen'),
          backgroundColor: const Color(0x00ffffff),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0x1fffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CategorieInputField(textController: _categorieTextController, errorText: _categorieErrorText, transactionType: TransactionType.outcome.name),
                MoneyInputField(textController: _budgetTextController, errorText: _budgetErrorText, hintText: 'Budget', bottomSheetTitle: 'Budget eingeben:'),
                SaveButton(saveFunction: _createOrUpdateBudget, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
