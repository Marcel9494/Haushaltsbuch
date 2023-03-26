import 'package:flutter/material.dart';

import '/models/categorie_stats.dart';

class ExpenditureCard extends StatelessWidget {
  final CategorieStats categorieStats;

  const ExpenditureCard({
    Key? key,
    required this.categorieStats,
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
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: categorieStats.statColor, width: 6)),
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
                        child: Text('${categorieStats.percentage.toStringAsFixed(0)} %'),
                      ),
                    ),
                    TextSpan(
                      text: categorieStats.categorieName,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                child: Text(categorieStats.amount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
