import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/default_budget_bloc/default_budget_bloc.dart';

import '/models/default_budget/default_budget_model.dart';

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
      onTap: () => BlocProvider.of<DefaultBudgetBloc>(context).add(LoadDefaultBudgetEvent(context, defaultBudget.categorie)),
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
