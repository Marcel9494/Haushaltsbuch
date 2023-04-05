import 'package:flutter/material.dart';

class MonthlyBudgetTabView extends StatefulWidget {
  const MonthlyBudgetTabView({Key? key}) : super(key: key);

  @override
  State<MonthlyBudgetTabView> createState() => _MonthlyBudgetTabViewState();
}

class _MonthlyBudgetTabViewState extends State<MonthlyBudgetTabView> {
  @override
  Widget build(BuildContext context) {
    return const Text('Budget');
  }
}
