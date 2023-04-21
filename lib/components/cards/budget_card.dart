import 'package:flutter/material.dart';

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
            border: Border(left: BorderSide(color: Colors.cyanAccent /* TODO dynamische Farbe implementieren */, width: 6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('TODO'),
                      ),
                    ),
                    TextSpan(
                      text: formatToMoneyAmount(budget.budget.toString()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                child: Text(budget.categorie),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
