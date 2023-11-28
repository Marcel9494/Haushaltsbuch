import 'package:flutter/material.dart';

import '/models/default_budget/default_budget_repository.dart';
import '/models/budget/budget_model.dart';
import '/models/budget/budget_repository.dart';
import '/models/default_budget/default_budget_model.dart';

import '/utils/consts/route_consts.dart';

import '/components/dialogs/choice_dialog.dart';
import '/components/deco/loading_indicator.dart';
import '/components/cards/default_budget_card.dart';
import '/components/cards/separate_budget_card.dart';
import '/components/buttons/year_picker_buttons.dart';

class EditBudgetScreen extends StatefulWidget {
  final Budget budget;

  const EditBudgetScreen({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  List<Budget> _budgetList = [];
  DefaultBudget _defaultBudget = DefaultBudget();
  DateTime _selectedYear = DateTime.now();
  BudgetRepository budgetRepository = BudgetRepository();

  Future<List<Budget>> _loadOneBudgetCategorie() async {
    DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
    _defaultBudget = await defaultBudgetRepository.load(widget.budget.categorie);
    _budgetList = await budgetRepository.loadOneBudgetCategorie(widget.budget.categorie, _selectedYear.year);
    return _budgetList;
  }

  void _deleteBudget() {
    showChoiceDialog(
        context, 'Budget löschen?', _yesPressed, _noPressed, 'Budget wurde gelöscht', 'Budget für ${widget.budget.categorie} wurde erfolgreich gelöscht.', Icons.info_outline);
  }

  void _yesPressed() {
    setState(() {
      budgetRepository.deleteAllBudgetsFromCategorie(widget.budget.categorie);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, overviewBudgetsRoute);
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _deleteBudget(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YearPickerButtons(selectedYear: _selectedYear, selectedYearCallback: (selectedYear) => setState(() => _selectedYear = selectedYear)),
          FutureBuilder(
            future: _loadOneBudgetCategorie(),
            builder: (BuildContext context, AsyncSnapshot<List<Budget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingIndicator();
                case ConnectionState.done:
                  if (_budgetList.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('Keine Budgets vorhanden'),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          DefaultBudgetCard(defaultBudget: _defaultBudget),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Divider(),
                          ),
                          RefreshIndicator(
                            onRefresh: () async {
                              _budgetList = await _loadOneBudgetCategorie();
                              setState(() {});
                              return;
                            },
                            color: Colors.cyanAccent,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _budgetList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SeparateBudgetCard(budget: _budgetList[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                default:
                  if (snapshot.hasError) {
                    return const Text('Budget Übersicht konnte nicht geladen werden.');
                  }
                  return const LoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
