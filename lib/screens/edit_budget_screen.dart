import 'package:flutter/material.dart';

import '/models/budget.dart';

import '/components/deco/loading_indicator.dart';
import '/components/cards/separate_budget_card.dart';

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

  Future<List<Budget>> _loadOneBudgetCategorie() async {
    _budgetList = await Budget.loadOneBudgetCategorie(widget.budget.categorie);
    return _budgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: Column(
        children: [
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
