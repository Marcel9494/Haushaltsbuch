import 'package:flutter/material.dart';

import '../components/buttons/month_picker_buttons.dart';
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
  DateTime _selectedDate = DateTime.now();

  double _completeBudgetAmount = 0.0;
  double _completeBudgetExpenditures = 0.0;

  Future<List<Budget>> _loadBudgetList() async {
    _budgetList = await Budget.loadMonthlyBudgetList(_selectedDate);
    _budgetList = await Budget.calculateCurrentExpenditure(_budgetList, _selectedDate);
    _budgetList = Budget.calculateBudgetPercentage(_budgetList);
    _completeBudgetAmount = await Budget.calculateCompleteBudgetAmount(_budgetList, _selectedDate);
    _completeBudgetExpenditures = await Budget.calculateCompleteBudgetExpenditures(_budgetList, _selectedDate);
    // TODO hier weitermachen und oben das Gesamtbudget und die bisherigen Gesamtausgaben anzeigen lassen als Card
    print('Budget: ' + _completeBudgetAmount.toString());
    print('Ausgaben: ' + _completeBudgetExpenditures.toString());
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
            Row(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => setState(() => _selectedDate = selectedDate)),
              ),
            ]),
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
                              return BudgetCard(budget: _budgetList[index], selectedDate: _selectedDate);
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
