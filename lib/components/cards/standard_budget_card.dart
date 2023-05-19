import 'package:flutter/material.dart';

import '../../utils/date_formatters/date_formatter.dart';
import '/models/budget.dart';
import '/models/screen_arguments/create_or_edit_budget_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class StandardBudgetCard extends StatefulWidget {
  final List<Budget> budgetList;

  const StandardBudgetCard({
    Key? key,
    required this.budgetList,
  }) : super(key: key);

  @override
  State<StandardBudgetCard> createState() => _StandardBudgetCardState();
}

class _StandardBudgetCardState extends State<StandardBudgetCard> {
  Budget standardBudget = Budget();

  @override
  void initState() {
    super.initState();
    _loadStandardBudget();
  }

  void _loadStandardBudget() {
    for (int i = 0; i < widget.budgetList.length; i++) {
      if (DateTime.parse(widget.budgetList[i].budgetDate).month == DateTime.now().month + 1 && DateTime.parse(widget.budgetList[i].budgetDate).year == DateTime.now().year) {
        standardBudget = widget.budgetList[i];
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, createOrEditBudgetRoute, arguments: CreateOrEditBudgetScreenArguments(-2, widget.budgetList[0].categorie)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.budgetList[0].categorie} Standardbudget'),
              Text(formatToMoneyAmount(standardBudget.budget.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
