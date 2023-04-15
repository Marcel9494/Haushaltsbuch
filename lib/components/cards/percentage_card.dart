import 'package:flutter/material.dart';

import '/models/percentage_stats.dart';

class PercentageCard extends StatelessWidget {
  final PercentageStats percentageStats;

  const PercentageCard({
    Key? key,
    required this.percentageStats,
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
            border: Border(left: BorderSide(color: percentageStats.statColor, width: 6)),
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
                        child: Text('${percentageStats.percentage.toStringAsFixed(0)} %'),
                      ),
                    ),
                    TextSpan(
                      text: percentageStats.name,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                child: Text(percentageStats.amount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
