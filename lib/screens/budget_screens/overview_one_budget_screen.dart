import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/budget_bloc/budget_bloc.dart';

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

class OverviewOneBudgetScreen extends StatefulWidget {
  //final Budget budget;

  const OverviewOneBudgetScreen({Key? key
      //required this.budget,
      })
      : super(key: key);

  @override
  State<OverviewOneBudgetScreen> createState() => _OverviewOneBudgetScreenState();
}

class _OverviewOneBudgetScreenState extends State<OverviewOneBudgetScreen> {
  List<Budget> _budgetList = [];
  DefaultBudget _defaultBudget = DefaultBudget();
  DateTime _selectedYear = DateTime.now();
  BudgetRepository budgetRepository = BudgetRepository();

  // TODO in Bloc umziehen
  void _deleteBudget() {
    //showChoiceDialog(
    //    context, 'Budget löschen?', _yesPressed, _noPressed, 'Budget wurde gelöscht', 'Budget für ${widget.budget.categorie} wurde erfolgreich gelöscht.', Icons.info_outline);
  }

  // TODO in Bloc umziehen
  void _yesPressed() {
    setState(() {
      //budgetRepository.deleteAllBudgetsFromCategorie(widget.budget.categorie);
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
    return SafeArea(
      child: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          if (budgetState is BudgetListLoadingState) {
            return const LoadingIndicator();
          } else if (budgetState is BudgetListLoadedState) {
            if (budgetState.budgetList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('Keine Budgets vorhanden'),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(budgetState.categorie + ' Budgets'),
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
                    DefaultBudgetCard(defaultBudget: budgetState.defaultBudget),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        // TODO _budgetList = await _loadOneBudgetCategorie();
                        setState(() {});
                        return;
                      },
                      color: Colors.cyanAccent,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: budgetState.budgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SeparateBudgetCard(budget: budgetState.budgetList[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Text("Fehler bei Budget editieren Seite");
          }
        },
      ),
    );
  }
}
