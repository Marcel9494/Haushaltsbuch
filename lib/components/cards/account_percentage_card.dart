import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/models/percentage_stats/percentage_stats_model.dart';

import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class AccountPercentageCard extends StatelessWidget {
  final PercentageStats percentageStats;

  const AccountPercentageCard({
    Key? key,
    required this.percentageStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: percentageStats.statColor, width: 6.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '${percentageStats.percentage.abs().toStringAsFixed(1).replaceAll('.', ',')} %\t\t${percentageStats.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                  child: Text(
                    formatToMoneyAmount(formatMoneyAmountToDouble(percentageStats.amount).abs().toString()),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: fadeAnimationInMs.ms);
  }
}
