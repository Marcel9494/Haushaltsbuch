import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/default_budget.dart';
import '/utils/consts/global_consts.dart';
import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/budget.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateOrEditBudgetScreen extends StatefulWidget {
  final int budgetBoxIndex;
  final String? budgetCategorie;

  const CreateOrEditBudgetScreen({
    Key? key,
    required this.budgetBoxIndex,
    this.budgetCategorie,
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
  late Budget _loadedBudget;
  late DefaultBudget _loadedDefaultBudget;

  @override
  void initState() {
    super.initState();
    if (widget.budgetBoxIndex == -2) {
      _loadDefaultBudget();
    } else if (widget.budgetBoxIndex != -1) {
      _loadBudget();
    }
  }

  Future<void> _loadBudget() async {
    _loadedBudget = await Budget.loadBudget(widget.budgetBoxIndex);
    _budgetTextController.text = formatToMoneyAmount(_loadedBudget.budget.toString());
  }

  Future<void> _loadDefaultBudget() async {
    _loadedDefaultBudget = await DefaultBudget.loadDefaultBudget(widget.budgetCategorie!);
    _budgetTextController.text = formatToMoneyAmount(_loadedDefaultBudget.defaultBudget.toString());
  }

  // TODO hier weitermachen und verhindern das für eine Kategorie mehrmals ein Budget angelegt wird.
  // Idee: Überhaupt nicht mehr anbieten, wenn bereits ein Budget erstellt wurde oder bestehendes Budget updaten?
  void _createOrUpdateBudget() {
    if (_validCategorie(_categorieTextController.text) == false || _validBudget(_budgetTextController.text) == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.budgetBoxIndex == -1) {
      Budget newBudget = Budget()
        ..categorie = _categorieTextController.text
        ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
        ..currentExpenditure = 0.0
        ..percentage = 0.0
        ..budgetDate = DateTime.now().toString();
      newBudget.createBudget(newBudget);
      DefaultBudget newDefaultBudget = DefaultBudget()
        ..categorie = _categorieTextController.text
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      newDefaultBudget.createDefaultBudget(newDefaultBudget);
    } else if (widget.budgetBoxIndex == -2) {
      DefaultBudget updatedDefaultBudget = DefaultBudget()
        ..categorie = _loadedDefaultBudget.categorie
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      updatedDefaultBudget.updateDefaultBudget(updatedDefaultBudget, _loadedDefaultBudget.categorie);
      Budget.updateAllFutureBudgetsFromCategorie(updatedDefaultBudget);
    } else {
      Budget updatedBudget = Budget()
        ..categorie = _loadedBudget.categorie
        ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
        ..currentExpenditure = _loadedBudget.currentExpenditure
        ..percentage = _loadedBudget.percentage
        ..budgetDate = _loadedBudget.budgetDate.toString();
      updatedBudget.updateBudget(updatedBudget, widget.budgetBoxIndex);
    }
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: transitionInMs), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        if (widget.budgetBoxIndex != -1) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
      }
    });
  }

  bool _validCategorie(String categorieInput) {
    if (_categorieTextController.text.isEmpty && widget.budgetBoxIndex == -1) {
      setState(() {
        _categorieErrorText = 'Bitte wählen Sie eine Kategorie aus.';
      });
      return false;
    }
    _categorieErrorText = '';
    return true;
  }

  bool _validBudget(String budgetInput) {
    if (_budgetTextController.text.isEmpty) {
      setState(() {
        _budgetErrorText = 'Bitte geben Sie ein Budget ein.';
      });
      return false;
    }
    _budgetErrorText = '';
    return true;
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
        appBar: AppBar(
          title: Text(widget.budgetBoxIndex == -1 ? 'Budget erstellen' : 'Budget bearbeiten'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0xff1c2b30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.budgetBoxIndex == -1
                    ? CategorieInputField(
                        textController: _categorieTextController,
                        errorText: _categorieErrorText,
                        transactionType: TransactionType.outcome.name,
                        title: 'Kategorie für Budget auswählen:',
                        autofocus: true)
                    : const SizedBox(),
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
