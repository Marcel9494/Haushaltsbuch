import 'package:flutter/material.dart';

import '/models/enums/budget_mode_types.dart';
import '/models/default_budget/default_budget_model.dart';
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
      onTap: () =>
          Navigator.pushNamed(context, createBudgetRoute, arguments: CreateOrEditBudgetScreenArguments(BudgetModeType.updateDefaultBudgetMode, -1, defaultBudget.categorie)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${defaultBudget.categorie} Standardbudget', overflow: TextOverflow.ellipsis, maxLines: 2),
                          Text(
                            formatToMoneyAmount(defaultBudget.defaultBudget.toString()),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      const Divider(),
                      const Text(
                        'Du kannst das Budget für jeden Monat anpassen. Wenn du das Standardbudget veränderst, wird es für den aktuellen und alle zukünftigen Monate angewendet.',
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
