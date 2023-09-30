import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/default_budget/default_budget_repository.dart';
import '/utils/consts/hive_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/components/dialogs/choice_dialog.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/subcategorie_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/budget/budget_model.dart';
import '/models/default_budget/default_budget_model.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/budget/budget_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/budget_mode_types.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateOrEditBudgetScreen extends StatefulWidget {
  final BudgetModeType budgetModeType;
  final int? budgetBoxIndex; // budgetBoxIndex == -1 = Budget bearbeiten / -2 = Standardbudget bearbeiten / >= 0 = Budget erstellen
  final String? budgetCategorie;

  const CreateOrEditBudgetScreen({
    Key? key,
    required this.budgetModeType,
    required this.budgetBoxIndex,
    this.budgetCategorie,
  }) : super(key: key);

  @override
  State<CreateOrEditBudgetScreen> createState() => _CreateOrEditBudgetScreenState();
}

class _CreateOrEditBudgetScreenState extends State<CreateOrEditBudgetScreen> {
  final TextEditingController _categorieTextController = TextEditingController();
  final TextEditingController _subcategorieTextController = TextEditingController();
  final TextEditingController _budgetTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  final BudgetRepository budgetRepository = BudgetRepository();
  final DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
  late DefaultBudget _loadedDefaultBudget;
  late Budget _loadedBudget;
  String _categorieErrorText = '';
  String _budgetErrorText = '';
  bool _budgetExistsAlready = false;
  bool _subbudgetExistsAlready = false;

  @override
  void initState() {
    super.initState();
    if (widget.budgetModeType == BudgetModeType.updateDefaultBudgetMode) {
      _loadDefaultBudget();
    } else if (widget.budgetBoxIndex != -1) {
      // TODO if mit BudgetModeType ersetzen
      _loadBudget();
    }
  }

  Future<void> _loadBudget() async {
    _loadedBudget = await budgetRepository.load(widget.budgetBoxIndex!);
    _budgetTextController.text = formatToMoneyAmount(_loadedBudget.budget.toString());
  }

  Future<void> _loadDefaultBudget() async {
    _loadedDefaultBudget = await defaultBudgetRepository.load(widget.budgetCategorie!);
    _budgetTextController.text = formatToMoneyAmount(_loadedDefaultBudget.defaultBudget.toString());
  }

  void _saveBudget() {
    if (_validCategorie(_categorieTextController.text) == false || _validBudget(_budgetTextController.text) == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.budgetModeType == BudgetModeType.budgetCreationMode) {
      if (_subcategorieTextController.text.isEmpty) {
        _createBudget();
      } else {
        _createSubbudget();
      }
    } else if (widget.budgetModeType == BudgetModeType.updateDefaultBudgetMode) {
      _updateAllFutureBudgets();
    } else {
      _updateBudget();
    }
    if (_budgetExistsAlready == false) {
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
  }

  void _createBudget() async {
    _budgetExistsAlready = await budgetRepository.existsBudgetForCategorie(_categorieTextController.text);
    if (_budgetExistsAlready) {
      showChoiceDialog(
          context,
          'Budget aktualisieren?',
          _yesPressed,
          _noPressed,
          'Budget wurde aktualisiert',
          'Budget ${_categorieTextController.text} wurde erfolgreich aktualisiert.',
          Icons.info_outline,
          'Budget für ${_categorieTextController.text} wurde bereits angelegt möchten Sie alle Budgeteinträge aktualisieren?');
    } else {
      Budget newBudget = Budget()
        ..categorie = _categorieTextController.text
        ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
        ..currentExpenditure = 0.0
        ..percentage = 0.0
        ..budgetDate = DateTime.now().toString();
      budgetRepository.create(newBudget);
      DefaultBudget newDefaultBudget = DefaultBudget()
        ..categorie = _categorieTextController.text
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      defaultBudgetRepository.create(newDefaultBudget);
    }
  }

  void _createSubbudget() async {
    // TODO muss in Subbudget Klasse ausgelagert werden
    SubbudgetRepository subbudgetRepository = SubbudgetRepository();
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    _budgetExistsAlready = await budgetRepository.existsBudgetForCategorie(_categorieTextController.text);
    _subbudgetExistsAlready = await subbudgetRepository.existsSubbudgetForCategorie(_subcategorieTextController.text);
    if (_budgetExistsAlready) {
      if (_subbudgetExistsAlready) {
        DefaultBudget updatedDefaultBudget = DefaultBudget()
          ..categorie = _subcategorieTextController.text.isEmpty ? _categorieTextController.text : _subcategorieTextController.text
          ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
        defaultBudgetRepository.update(updatedDefaultBudget);
        subbudgetRepository.updateAllSubbudgetsForCategorie(_subcategorieTextController.text, formatMoneyAmountToDouble(_budgetTextController.text));
      } else {
        for (int i = 0; i < 3; i++) {
          DateTime date = DateTime.now();
          Subbudget subbudget = Subbudget()
            ..boxIndex = i
            ..subcategorieBudget = formatMoneyAmountToDouble(_budgetTextController.text)
            ..subcategorieName = _subcategorieTextController.text
            ..currentSubcategoriePercentage = 0.0
            ..currentSubcategorieExpenditure = 0.0
            ..categorie = _categorieTextController.text
            ..budgetDate = DateTime(date.year, date.month + i, 1).toString();
          subbudgetRepository.createInstance(subbudget);
          subbudgetBox.add(subbudget);
        }
        DefaultBudget newDefaultSubcategoriebudget = DefaultBudget()
          ..categorie = _subcategorieTextController.text
          ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
        defaultBudgetRepository.create(newDefaultSubcategoriebudget);
        CategorieRepository categorieRepository = CategorieRepository();
        List<String> subcategorieNames = await categorieRepository.loadSubcategorieNameList(_categorieTextController.text);
        subbudgetRepository.createSubbudgets(_categorieTextController.text, _subcategorieTextController.text, subcategorieNames);
      }
    } else {
      Budget newBudget = Budget()
        ..categorie = _categorieTextController.text
        ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
        ..currentExpenditure = 0.0
        ..percentage = 0.0
        ..budgetDate = DateTime.now().toString();
      budgetRepository.create(newBudget);
      DefaultBudget newDefaultBudget = DefaultBudget()
        ..categorie = _categorieTextController.text
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      defaultBudgetRepository.create(newDefaultBudget);
      if (_subbudgetExistsAlready) {
        DefaultBudget updatedDefaultBudget = DefaultBudget()
          ..categorie = _subcategorieTextController.text.isEmpty ? _categorieTextController.text : _subcategorieTextController.text
          ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
        defaultBudgetRepository.update(updatedDefaultBudget);
        subbudgetRepository.updateAllSubbudgetsForCategorie(_subcategorieTextController.text, formatMoneyAmountToDouble(_budgetTextController.text));
      } else {
        for (int i = 0; i < 3; i++) {
          DateTime date = DateTime.now();
          Subbudget subbudget = Subbudget()
            ..boxIndex = i
            ..subcategorieBudget = formatMoneyAmountToDouble(_budgetTextController.text)
            ..subcategorieName = _subcategorieTextController.text
            ..currentSubcategoriePercentage = 0.0
            ..currentSubcategorieExpenditure = 0.0
            ..categorie = _categorieTextController.text
            ..budgetDate = DateTime(date.year, date.month + i, 1).toString();
          subbudgetRepository.createInstance(subbudget);
          subbudgetBox.add(subbudget);
        }
        DefaultBudget newDefaultSubcategoriebudget = DefaultBudget()
          ..categorie = _subcategorieTextController.text
          ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
        defaultBudgetRepository.create(newDefaultSubcategoriebudget);
        CategorieRepository categorieRepository = CategorieRepository();
        List<String> subcategorieNames = await categorieRepository.loadSubcategorieNameList(_categorieTextController.text);
        subbudgetRepository.createSubbudgets(_categorieTextController.text, _subcategorieTextController.text, subcategorieNames);
      }
    }
  }

  void _updateAllFutureBudgets() async {
    DefaultBudget updatedDefaultBudget = DefaultBudget()
      ..categorie = _loadedDefaultBudget.categorie
      ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
    defaultBudgetRepository.update(updatedDefaultBudget);
    budgetRepository.updateAllFutureBudgetsFromCategorie(updatedDefaultBudget);
  }

  void _updateBudget() {
    Budget updatedBudget = Budget()
      ..categorie = _loadedBudget.categorie
      ..budget = formatMoneyAmountToDouble(_budgetTextController.text)
      ..currentExpenditure = 0.0
      ..percentage = 0.0
      ..budgetDate = _loadedBudget.budgetDate.toString();
    budgetRepository.update(updatedBudget, widget.budgetBoxIndex!);
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

  void _yesPressed() {
    setState(() {
      DefaultBudget updatedDefaultBudget = DefaultBudget()
        ..categorie = _subcategorieTextController.text.isEmpty ? _categorieTextController.text : _subcategorieTextController.text
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      defaultBudgetRepository.update(updatedDefaultBudget);
      budgetRepository.updateAllBudgetsFromCategorie(updatedDefaultBudget);
    });
    _setSaveButtonAnimation(true);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    _setSaveButtonAnimation(false);
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
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
                        categorieType: CategorieTypeExtension.getCategorieType(TransactionType.outcome.name),
                        categorieStringCallback: (categorie) => setState(() => _categorieTextController.text = categorie),
                        title: 'Kategorie für Budget auswählen:',
                        autofocus: true)
                    : const SizedBox(),
                SubcategorieInputField(textController: _subcategorieTextController, categorieName: _categorieTextController.text),
                MoneyInputField(textController: _budgetTextController, errorText: _budgetErrorText, hintText: 'Budget', bottomSheetTitle: 'Budget eingeben:'),
                SaveButton(saveFunction: _saveBudget, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
