import 'package:flutter/material.dart';

import '../cards/overview_tile_card.dart';
import '/utils/number_formatters/number_formatter.dart';

class OverviewTile extends StatelessWidget {
  final String shouldText;
  final double should;
  final String haveText;
  final double have;
  final String balanceText;
  final String investmentText;
  final double investmentAmount;
  final String availableText;
  final bool showInvestments;
  final bool showAvailable;
  final bool showAverageValuesPerDay;

  const OverviewTile({
    Key? key,
    required this.shouldText,
    required this.should,
    required this.haveText,
    required this.have,
    required this.balanceText,
    this.investmentText = '',
    this.investmentAmount = 0.0,
    this.availableText = '',
    this.showInvestments = false,
    this.showAvailable = false,
    this.showAverageValuesPerDay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OverviewTileCard(
            text: shouldText,
            amount: should,
            showAverageValuesPerDay: showAverageValuesPerDay,
            color: Colors.greenAccent,
          ),
          OverviewTileCard(
            text: haveText,
            amount: have,
            showAverageValuesPerDay: showAverageValuesPerDay,
            color: const Color(0xfff4634f),
          ),
          OverviewTileCard(
            text: balanceText,
            amount: should - have.abs(),
            showAverageValuesPerDay: showAverageValuesPerDay,
            color: (should - have.abs()) >= 0 ? Colors.greenAccent : Colors.redAccent,
          ),
          if (showInvestments)
            OverviewTileCard(
              text: investmentText,
              amount: investmentAmount,
              showAverageValuesPerDay: showAverageValuesPerDay,
              color: Colors.cyanAccent,
            ),
          if (showAvailable)
            OverviewTileCard(
              text: availableText,
              amount: should - have.abs() - investmentAmount.abs(),
              showAverageValuesPerDay: showAverageValuesPerDay,
              color: (should - have.abs() - investmentAmount.abs()) >= 0 ? Colors.greenAccent : Colors.redAccent,
            ),
        ],
      ),
    );
  }
}
