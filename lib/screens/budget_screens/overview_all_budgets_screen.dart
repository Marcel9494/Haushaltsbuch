import 'package:flutter/material.dart';

import '/models/budget/budget_model.dart';
import '/models/budget/budget_repository.dart';

import '/components/cards/edit_budget_card.dart';
import '/components/deco/loading_indicator.dart';

class OverviewAllBudgetsScreen extends StatefulWidget {
  const OverviewAllBudgetsScreen({Key? key}) : super(key: key);

  @override
  State<OverviewAllBudgetsScreen> createState() => _OverviewAllBudgetsScreenState();
}

// TODO hier weitermachen und Budgets verwalten um Unterkategorien erweitern.
// TODO Dabei den Benutzer auf dieser Seite auswählen lassen können, ob er eine
// TODO Hauptkategorie oder Unterkategorie bearbeiten möchte.
class _OverviewAllBudgetsScreenState extends State<OverviewAllBudgetsScreen> {
  List<Budget> _budgetList = [];

  Future<List<Budget>> _loadAllBudgetCategories() async {
    BudgetRepository budgetRepository = BudgetRepository();
    _budgetList = await budgetRepository.loadAllBudgetCategories();
    return _budgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets verwalten')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
            child: Text(
              'Budgetliste:',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          FutureBuilder(
            future: _loadAllBudgetCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<Budget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingIndicator();
                case ConnectionState.done:
                  if (_budgetList.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('Noch keine Budgets erstellt.'),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              _budgetList = await _loadAllBudgetCategories();
                              setState(() {});
                              return;
                            },
                            color: Colors.cyanAccent,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _budgetList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return EditBudgetCard(budget: _budgetList[index]);
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
