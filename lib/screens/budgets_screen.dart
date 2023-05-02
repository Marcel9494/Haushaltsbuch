import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  double _completeBudgetPercentage = 0.0;

  Future<List<Budget>> _loadBudgetList() async {
    _budgetList = await Budget.loadMonthlyBudgetList(_selectedDate);
    _budgetList = await Budget.calculateCurrentExpenditure(_budgetList, _selectedDate);
    _budgetList = Budget.calculateBudgetPercentage(_budgetList);
    _completeBudgetAmount = await Budget.calculateCompleteBudgetAmount(_budgetList, _selectedDate);
    _completeBudgetExpenditures = await Budget.calculateCompleteBudgetExpenditures(_budgetList, _selectedDate);
    // TODO hier weitermachen und Gesamtbudget richtig berechnen und Code verbessern (Berechnung in Methode auslagern)
    _completeBudgetPercentage = (_completeBudgetExpenditures * 100) / _completeBudgetAmount;
    _budgetList.sort((first, second) => second.percentage.compareTo(first.percentage));
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
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => setState(() => _selectedDate = selectedDate)),
                ),
              ],
            ),
            CircularPercentIndicator(
              radius: 36.0,
              lineWidth: 4.0,
              percent: _completeBudgetPercentage / 100 >= 1.0 ? 1.0 : _completeBudgetPercentage / 100,
              center: Text('${_completeBudgetPercentage.toString()} %', style: const TextStyle(fontSize: 12.0)),
              progressColor: _completeBudgetPercentage < 80.0
                  ? Colors.greenAccent
                  : _completeBudgetPercentage < 100.0
                      ? Colors.yellowAccent
                      : Colors.redAccent,
              backgroundWidth: 2.0,
              animation: true,
              animateFromLastPercent: true,
            ),
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
