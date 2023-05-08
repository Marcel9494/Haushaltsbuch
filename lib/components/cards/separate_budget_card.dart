import 'package:flutter/material.dart';
import 'package:haushaltsbuch/utils/number_formatters/number_formatter.dart';

import '/models/budget.dart';

class SeparateBudgetCard extends StatelessWidget {
  final Budget budget;

  const SeparateBudgetCard({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(formatToMoneyAmount(budget.budget.toString())),
        ],
      ),
    );
  }
}
