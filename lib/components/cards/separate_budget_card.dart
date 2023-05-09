import 'package:flutter/material.dart';

import '../../models/screen_arguments/create_or_edit_budget_screen_arguments.dart';
import '../../utils/consts/route_consts.dart';
import '/models/budget.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateFormatterMMMM.format(DateTime.parse(budget.budgetDate))),
            Text(formatToMoneyAmount(budget.budget.toString())),
          ],
        ),
      ),
    );
  }
}
