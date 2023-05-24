import 'package:flutter/material.dart';

import '/utils/number_formatters/number_formatter.dart';

class OverviewTile extends StatelessWidget {
  final String shouldText;
  final double should;
  final String haveText;
  final double have;
  final String balanceText;
  final String investmentText;
  final double investmentAmount;
  final bool showInvestments;
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
    this.showInvestments = false,
    this.showAverageValuesPerDay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: '$shouldText\n'),
              TextSpan(
                text: formatToMoneyAmount(should.toString()) + '\n',
                style: const TextStyle(height: 1.5, color: Colors.greenAccent, fontSize: 15.0),
              ),
              showAverageValuesPerDay
                  ? TextSpan(
                      text: 'Ø ${formatToMoneyAmount((should / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString())}',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 15.0),
                    )
                  : const WidgetSpan(child: SizedBox()),
            ]),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: '$haveText\n'),
              TextSpan(
                text: formatToMoneyAmount(have.abs().toString()) + '\n',
                style: const TextStyle(height: 1.5, color: Color(0xfff4634f), fontSize: 15.0),
              ),
              showAverageValuesPerDay
                  ? TextSpan(
                      text: 'Ø ${formatToMoneyAmount((have / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString())}',
                      style: const TextStyle(color: Color(0xfff4634f), fontSize: 15.0),
                    )
                  : const WidgetSpan(child: SizedBox()),
            ]),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: '$balanceText\n'),
              TextSpan(
                text: formatToMoneyAmount((should - have.abs()).toString()) + '\n',
                style: TextStyle(height: 1.5, color: (should - have.abs()) >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 15.0),
              ),
              showAverageValuesPerDay
                  ? TextSpan(
                      text: 'Ø ${formatToMoneyAmount(((should - have.abs()) / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString())}',
                      style: TextStyle(color: (should - have.abs()) >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 15.0),
                    )
                  : const WidgetSpan(child: SizedBox()),
            ]),
          ),
          if (showInvestments)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: '$investmentText\n'),
                TextSpan(
                  text: formatToMoneyAmount(investmentAmount.toString()) + '\n',
                  style: const TextStyle(height: 1.5, color: Colors.cyanAccent, fontSize: 15.0),
                ),
                showAverageValuesPerDay
                    ? TextSpan(
                        text: 'Ø ${formatToMoneyAmount((investmentAmount / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString())}',
                        style: const TextStyle(color: Colors.cyanAccent, fontSize: 15.0),
                      )
                    : const WidgetSpan(child: SizedBox()),
              ]),
            ),
        ],
      ),
    );
  }
}
