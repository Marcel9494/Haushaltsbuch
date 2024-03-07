import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/subbudget_bloc/subbudget_bloc.dart';
import '/blocs/budget_bloc/budget_bloc.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';
import '/blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';

import '/utils/consts/hive_consts.dart';
import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/components/deco/loading_indicator.dart';
import '/components/dialogs/choice_dialog.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/subcategorie_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/budget/budget_model.dart';
import '/models/default_budget/default_budget_model.dart';
import '/models/default_budget/default_budget_repository.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/budget/budget_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({Key? key}) : super(key: key);

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  late final BudgetBloc budgetBloc;
  late final SubbudgetBloc subbudgetBloc;

  late final CategorieInputFieldCubit categorieInputFieldCubit;
  late final SubcategorieInputFieldCubit subcategorieInputFieldCubit;
  late final MoneyInputFieldCubit moneyInputFieldCubit;

  FocusNode categorieFocusNode = FocusNode();
  FocusNode subcategorieFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  final TextEditingController _categorieTextController = TextEditingController();
  final TextEditingController _subcategorieTextController = TextEditingController();
  final TextEditingController _budgetTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  final BudgetRepository budgetRepository = BudgetRepository();
  final DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
  bool _budgetExistsAlready = false;
  bool _subbudgetExistsAlready = false;

  @override
  void initState() {
    super.initState();
    budgetBloc = BlocProvider.of<BudgetBloc>(context);
    subbudgetBloc = BlocProvider.of<SubbudgetBloc>(context);
    categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(context);
    subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(context);
    moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
  }

  // TODO nicht mehr benutzte Funktion entfernen?
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

  void _yesPressed() {
    setState(() {
      DefaultBudget updatedDefaultBudget = DefaultBudget()
        ..categorie = _subcategorieTextController.text.isEmpty ? _categorieTextController.text : _subcategorieTextController.text
        ..defaultBudget = formatMoneyAmountToDouble(_budgetTextController.text);
      defaultBudgetRepository.update(updatedDefaultBudget);
      budgetRepository.updateAllBudgetsFromCategorie(updatedDefaultBudget);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(1));
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          if (budgetState is BudgetInitializingState) {
            return const LoadingIndicator();
          } else if (budgetState is BudgetInitializedState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Budget erstellen'),
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
                      BlocBuilder<CategorieInputFieldCubit, CategorieInputFieldModel>(
                        builder: (context, state) {
                          return CategorieInputField(
                            cubit: categorieInputFieldCubit,
                            focusNode: categorieFocusNode,
                            categorieType: CategorieTypeExtension.getCategorieType(TransactionType.outcome.name),
                          );
                        },
                      ),
                      BlocBuilder<SubcategorieInputFieldCubit, String>(
                        builder: (context, state) {
                          return SubcategorieInputField(cubit: subcategorieInputFieldCubit, focusNode: subcategorieFocusNode);
                        },
                      ),
                      BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                        builder: (context, state) {
                          return MoneyInputField(cubit: moneyInputFieldCubit, focusNode: amountFocusNode, hintText: 'Budget', bottomSheetTitle: 'Budget eingeben:');
                        },
                      ),
                      SaveButton(
                          saveFunction: () => subcategorieInputFieldCubit.state.isEmpty
                              ? budgetBloc.add(CreateBudgetEvent(context, _saveButtonController))
                              : subbudgetBloc.add(CreateSubbudgetEvent(context, _saveButtonController)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Budgetseite");
          }
        },
      ),
    );
  }
}
