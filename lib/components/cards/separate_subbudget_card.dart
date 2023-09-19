import 'package:flutter/material.dart';

import '/models/subbudget.dart';
import '/models/enums/budget_mode_types.dart';
import '/models/screen_arguments/create_or_edit_budget_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class SeparateSubbudgetCard extends StatelessWidget {
  final Subbudget subbudget;

  const SeparateSubbudgetCard({
    Key? key,
    required this.subbudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, createOrEditBudgetRoute, arguments: CreateOrEditBudgetScreenArguments(BudgetModeType.budgetCreationMode, subbudget.boxIndex)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: DateTime.parse(subbudget.budgetDate).month == DateTime.now().month && DateTime.parse(subbudget.budgetDate).year == DateTime.now().year
                          ? Colors.cyanAccent
                          : Colors.transparent,
                      width: 3.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DateTime.parse(subbudget.budgetDate).month == DateTime.now().month && DateTime.parse(subbudget.budgetDate).year == DateTime.now().year
                                ? Colors.cyanAccent
                                : Colors.blueGrey)),
                    child: dateFormatterMMMM.format(DateTime.parse(subbudget.budgetDate)).length > 3
                        ? Text('${dateFormatterMMM.format(DateTime.parse(subbudget.budgetDate))}.')
                        : Text(dateFormatterMMM.format(DateTime.parse(subbudget.budgetDate))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(formatToMoneyAmount(subbudget.subcategorieBudget.toString())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}