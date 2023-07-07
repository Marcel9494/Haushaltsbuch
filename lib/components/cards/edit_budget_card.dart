import 'package:flutter/material.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/budget.dart';
import '/models/screen_arguments/edit_budget_screen_arguments.dart';

class EditBudgetCard extends StatefulWidget {
  final Budget budget;

  const EditBudgetCard({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  State<EditBudgetCard> createState() => _EditBudgetCardState();
}

class _EditBudgetCardState extends State<EditBudgetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, editBudgetRoute, arguments: EditBudgetScreenArguments(widget.budget)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(widget.budget.categorie, overflow: TextOverflow.ellipsis),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(formatToMoneyAmount(widget.budget.budget.toString()), overflow: TextOverflow.ellipsis),
            ),
            const Expanded(
              flex: 1,
              child: Icon(Icons.edit_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
