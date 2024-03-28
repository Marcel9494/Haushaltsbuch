import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class OverviewTileCard extends StatelessWidget {
  final String text;
  final double amount;
  final bool showAverageValuesPerDay;
  final Color color;

  const OverviewTileCard({
    Key? key,
    required this.text,
    required this.amount,
    required this.showAverageValuesPerDay,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: SizedBox(
        width: 104.0,
        height: showAverageValuesPerDay ? 70.0 : 56.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: '$text\n'),
              TextSpan(
                text: amount.ceil().toString().length <= 5 ? formatToMoneyAmount(amount.toString()) + '\n' : amount.ceil().toString().length <= 8 ? formatToMoneyAmountWithoutCent(amount.toString()) : formatToMoneyAmountWithoutCentAndSymbol(amount.toString()),
                style: TextStyle(height: 1.5, color: color, fontSize: 15.0, overflow: TextOverflow.ellipsis),
              ),
              showAverageValuesPerDay
                  ? TextSpan(
                      text: '${formatToMoneyAmount((amount / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString())} pro Tag',
                      style: TextStyle(height: 1.2, color: Colors.grey.shade400, fontSize: 10.0, overflow: TextOverflow.ellipsis),
                    )
                  : const WidgetSpan(child: SizedBox()),
            ]),
          ),
        ),
      ),
    ).animate().fade(duration: fadeAnimationInMs.ms);
  }
}
