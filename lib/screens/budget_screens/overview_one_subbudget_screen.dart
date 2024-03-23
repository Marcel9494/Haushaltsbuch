import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/subbudget_bloc/subbudget_bloc.dart';

import '/components/dialogs/choice_dialog_with_flushbar.dart';
import '/components/deco/loading_indicator.dart';
import '/components/cards/default_budget_card.dart';
import '/components/buttons/year_picker_buttons.dart';
import '/components/cards/separate_subbudget_card.dart';

class OverviewOneSubbudgetScreen extends StatefulWidget {
  const OverviewOneSubbudgetScreen({Key? key}) : super(key: key);

  @override
  State<OverviewOneSubbudgetScreen> createState() => _OverviewOneSubbudgetScreenState();
}

class _OverviewOneSubbudgetScreenState extends State<OverviewOneSubbudgetScreen> {
  final DateTime _selectedYear = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SubbudgetBloc, SubbudgetState>(
        builder: (context, budgetState) {
          if (budgetState is SubbudgetLoadingState) {
            return const LoadingIndicator();
          } else if (budgetState is SubbudgetLoadedState) {
            if (budgetState.subbudgetList.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(budgetState.categorie + ' Budgets'),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => showChoiceDialogWithFlushbar(
                          context,
                          'Budget löschen?',
                          () => SchedulerBinding.instance.addPostFrameCallback((_) {
                                BlocProvider.of<SubbudgetBloc>(context).add(DeleteSubbudgetEvent(context, budgetState.categorie));
                              }),
                          () => Navigator.pop(context),
                          'Budget wurde gelöscht',
                          'Budget für ${budgetState.categorie} wurde erfolgreich gelöscht.',
                          Icons.info_outline),
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
                            BlocProvider.of<SubbudgetBloc>(context).add(LoadSubbudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false))),
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
                      onPressed: () => showChoiceDialogWithFlushbar(
                          context,
                          'Budget löschen?',
                          () => SchedulerBinding.instance.addPostFrameCallback((_) {
                                BlocProvider.of<SubbudgetBloc>(context).add(DeleteSubbudgetEvent(context, budgetState.categorie));
                              }),
                          () => Navigator.pop(context),
                          'Budget wurde gelöscht',
                          'Budget für ${budgetState.categorie} wurde erfolgreich gelöscht.',
                          Icons.info_outline),
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
                            BlocProvider.of<SubbudgetBloc>(context).add(LoadSubbudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false))),
                    DefaultBudgetCard(defaultBudget: budgetState.defaultBudget),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<SubbudgetBloc>(context).add(LoadSubbudgetListFromOneCategorieEvent(context, -1, budgetState.categorie, _selectedYear.year, false));
                        },
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          itemCount: budgetState.subbudgetList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SeparateSubbudgetCard(subbudget: budgetState.subbudgetList[index]);
                          },
                        ),
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
