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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: '$shouldText\n'),
              TextSpan(
                text: formatToMoneyAmount(should.toString()),
                style: const TextStyle(height: 1.5, color: Colors.greenAccent, fontSize: 15.0),
              ),
            ]),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: '$haveText\n'),
              TextSpan(
                text: formatToMoneyAmount(have.toString()),
                style: const TextStyle(height: 1.5, color: Color(0xfff4634f), fontSize: 15.0),
              ),
            ]),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: '$balanceText\n'),
              TextSpan(
                text: formatToMoneyAmount((should - have).toString()),
                style: TextStyle(height: 1.5, color: (should - have) >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 15.0),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
