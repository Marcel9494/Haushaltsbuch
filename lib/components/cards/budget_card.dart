import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/models/budget.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final DateTime selectedDate;

  const BudgetCard({
    Key? key,
    required this.budget,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(selectedDate, budget.categorie)),
      child: Card(
        color: const Color(0xff1c2b30),
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
                    color: budget.percentage < 80.0
                        ? Colors.greenAccent
                        : budget.percentage < 100.0
                            ? Colors.yellowAccent
                            : Colors.redAccent,
                    width: 6.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(budget.categorie),
                        ),
                      ),
                      TextSpan(
                        text: '${formatToMoneyAmount(budget.currentExpenditure.toString())} / ${formatToMoneyAmount(budget.budget.toString())}',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: CircularPercentIndicator(
                    radius: 26.0,
                    lineWidth: 4.0,
                    percent: budget.percentage / 100 >= 1.0 ? 1.0 : budget.percentage / 100,
                    center: Text('${budget.percentage.toStringAsFixed(0)} %', style: const TextStyle(fontSize: 12.0)),
                    progressColor: budget.percentage < 80.0
                        ? Colors.greenAccent
                        : budget.percentage < 100.0
                            ? Colors.yellowAccent
                            : Colors.redAccent,
                    backgroundWidth: 2.0,
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
