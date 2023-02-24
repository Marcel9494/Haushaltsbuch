import 'package:flutter/material.dart';

import '/utils/number_formatters/number_formatter.dart';

class OverviewTile extends StatelessWidget {
  final String shouldText;
  final double should;
  final String haveText;
  final double have;
  final String balanceText;

  const OverviewTile({
    Key? key,
    required this.shouldText,
    required this.should,
    required this.haveText,
    required this.have,
    required this.balanceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('$shouldText\n${formatToMoneyAmount(should.toString())}', textAlign: TextAlign.center),
        Text('$haveText\n${formatToMoneyAmount(have.toString())}', textAlign: TextAlign.center),
        Text('$balanceText\n${formatToMoneyAmount((should - have).toString())}', textAlign: TextAlign.center),
      ],
    );
  }
}
