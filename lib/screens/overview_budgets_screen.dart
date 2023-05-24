import 'package:flutter/material.dart';

import '/models/budget.dart';

import '/components/cards/edit_budget_card.dart';
import '/components/deco/loading_indicator.dart';

class OverviewBudgetsScreen extends StatefulWidget {
  const OverviewBudgetsScreen({Key? key}) : super(key: key);

  @override
  State<OverviewBudgetsScreen> createState() => _OverviewBudgetsScreenState();
}

class _OverviewBudgetsScreenState extends State<OverviewBudgetsScreen> {
  List<Budget> _budgetList = [];

  Future<List<Budget>> _loadAllBudgetCategories() async {
    _budgetList = await Budget.loadAllBudgetCategories();
    return _budgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets verwalten')),
      body: Column(
        children: [
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