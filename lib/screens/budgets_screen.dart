import 'package:flutter/material.dart';

import '/components/cards/budget_card.dart';
import '/components/deco/loading_indicator.dart';

import '/models/budget.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  List<Budget> _budgetList = [];

  Future<List<Budget>> _loadBudgetList() async {
    _budgetList = await Budget.loadBudgets();
    _budgetList[0].
    return _budgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: _loadBudgetList(),
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
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _budgetList = await _loadBudgetList();
                            setState(() {});
                            return;
                          },
                          color: Colors.cyanAccent,
                          child: ListView.builder(
                            itemCount: _budgetList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BudgetCard(budget: _budgetList[index]);
                            },
                          ),
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
      ),
    );
  }
}
