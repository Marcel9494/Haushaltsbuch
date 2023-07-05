import 'package:flutter/material.dart';

import '/models/default_budget.dart';
import '/models/screen_arguments/create_or_edit_budget_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class DefaultBudgetCard extends StatelessWidget {
  final DefaultBudget defaultBudget;

  const DefaultBudgetCard({
    Key? key,
    required this.defaultBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, createOrEditBudgetRoute, arguments: CreateOrEditBudgetScreenArguments(-2, defaultBudget.categorie)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text('${defaultBudget.categorie} Standardbudget', overflow: TextOverflow.ellipsis, maxLines: 2),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  formatToMoneyAmount(defaultBudget.defaultBudget.toString()),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
