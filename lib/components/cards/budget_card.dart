import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/models/budget.dart';

import '/utils/number_formatters/number_formatter.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;

  const BudgetCard({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1c2b30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.cyanAccent /* TODO dynamische Farbe implementieren */, width: 6.0)),
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
                  radius: 24.0,
                  lineWidth: 4.5,
                  percent: budget.percentage / 100,
                  center: Text('${budget.percentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12.0)),
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
    );
  }
}
