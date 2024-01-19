import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/budget_bloc/budget_bloc.dart';

import '/components/deco/loading_indicator.dart';
import '/components/cards/default_budget_card.dart';
import '/components/cards/separate_budget_card.dart';
import '/components/buttons/year_picker_buttons.dart';

class OverviewOneBudgetScreen extends StatefulWidget {
  const OverviewOneBudgetScreen({Key? key}) : super(key: key);

  @override
  State<OverviewOneBudgetScreen> createState() => _OverviewOneBudgetScreenState();
}

class _OverviewOneBudgetScreenState extends State<OverviewOneBudgetScreen> {
  final DateTime _selectedYear = DateTime.now();

  // TODO in Bloc umziehen
  void _deleteBudget() {
    //showChoiceDialog(
    //    context, 'Budget löschen?', _yesPressed, _noPressed, 'Budget wurde gelöscht', 'Budget für ${widget.budget.categorie} wurde erfolgreich gelöscht.', Icons.info_outline);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          if (budgetState is BudgetLoadingState) {
            return const LoadingIndicator();
          } else if (budgetState is BudgetLoadedState) {
            if (budgetState.budgetList.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(budgetState.categorie + ' Budgets'),
                  actions: <Widget>[
                    IconButton(
                      // TODO hier weitermachen und deleteBudget in Bloc auslagern
                      onPressed: () => _deleteBudget(),
                      icon: const Icon(Icons.delete_forever_rounded),
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YearPickerButtons(
                        selectedYear: DateTime.parse(budgetState.selectedYear.toString() + "-01-01"),
                        selectedYearCallback: (_selectedYear) =>
                            BlocProvider.of<BudgetBloc>(context).add(LoadBudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false))),
                    DefaultBudgetCard(defaultBudget: budgetState.defaultBudget),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                  ],
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
                    YearPickerButtons(
                        selectedYear: DateTime.parse(budgetState.selectedYear.toString() + "-01-01"),
                        selectedYearCallback: (_selectedYear) =>
                            BlocProvider.of<BudgetBloc>(context).add(LoadBudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false))),
                    DefaultBudgetCard(defaultBudget: budgetState.defaultBudget),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<BudgetBloc>(context).add(LoadBudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false));
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
            return const Text("Fehler bei Budget Übersichts Seite");
          }
        },
      ),
    );
  }
}
