import 'package:flutter/material.dart';

import '/models/budget.dart';
import '/models/screen_arguments/create_or_edit_budget_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class SeparateBudgetCard extends StatelessWidget {
  final Budget budget;

  const SeparateBudgetCard({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, createOrEditBudgetRoute, arguments: CreateOrEditBudgetScreenArguments(budget.boxIndex)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: DateTime.parse(budget.budgetDate).month == DateTime.now().month && DateTime.parse(budget.budgetDate).year == DateTime.now().year
                            ? Colors.cyanAccent
                            : Colors.blueGrey)),
                child: dateFormatterMMMM.format(DateTime.parse(budget.budgetDate)).length > 3
                    ? Text('${dateFormatterMMM.format(DateTime.parse(budget.budgetDate))}.')
                    : Text(dateFormatterMMM.format(DateTime.parse(budget.budgetDate))),
              ),
              Text(formatToMoneyAmount(budget.budget.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
