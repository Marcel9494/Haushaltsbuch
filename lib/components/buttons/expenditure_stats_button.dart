import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/models/enums/outcome_statistic_types.dart';

import '../deco/bottom_sheet_line.dart';

typedef SelectedOutcomeStatisticTypeCallback = void Function(String outcomeStatisticType);

class ExpenditureStatsButton extends StatelessWidget {
  String outcomeStatisticType;
  final SelectedOutcomeStatisticTypeCallback selectedOutcomeStatisticTypeCallback;
  final Function expenditureFunction;
  final Function expenditureAndSavingrateFunction;
  final Function expenditureSavingrateAndInvestmentrateFunction;

  ExpenditureStatsButton({
    Key? key,
    required this.outcomeStatisticType,
    required this.selectedOutcomeStatisticTypeCallback,
    required this.expenditureFunction,
    required this.expenditureAndSavingrateFunction,
    required this.expenditureSavingrateAndInvestmentrateFunction,
  }) : super(key: key);

  void _openBottomSheetMenu(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: ListView(
            shrinkWrap: true,
            children: [
              const BottomSheetLine(),
              const Padding(
                padding: EdgeInsets.only(top: 12.0, left: 20.0, bottom: 8.0),
                child: Text('Auswählen:', style: TextStyle(fontSize: 18.0)),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () => {
                      expenditureFunction,
                      selectedOutcomeStatisticTypeCallback(OutcomeStatisticType.outcome.name),
                      Navigator.pop(context),
                    },
                    leading: const Icon(Icons.local_grocery_store_rounded, color: Colors.cyanAccent),
                    title: const Text('Nur Ausgaben'),
                    subtitle: const Text('Es werden alle Ausgaben angezeigt.'),
                  ),
                  ListTile(
                    onTap: () => {
                      expenditureAndSavingrateFunction,
                      selectedOutcomeStatisticTypeCallback(OutcomeStatisticType.savingrate.name),
                      Navigator.pop(context),
                    },
                    leading: const Icon(Icons.savings_rounded, color: Colors.cyanAccent),
                    title: const Text('Ausgaben + Sparquote'),
                    subtitle: const Text('Zur Sparquote zählen alle Investitionen und übrige Geldmittel.'),
                  ),
                  ListTile(
                    onTap: () => {
                      expenditureSavingrateAndInvestmentrateFunction,
                      selectedOutcomeStatisticTypeCallback(OutcomeStatisticType.investmentrate.name),
                      Navigator.pop(context),
                    },
                    leading: const Icon(Icons.volunteer_activism_rounded, color: Colors.cyanAccent),
                    title: const Text('Ausgaben + Spar- & Investitionsquote'),
                    subtitle: const Text('Die Spar- und Investitionsquote werden als einzelne Positionen angezeigt.'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 12.0),
      child: OutlinedButton(
        onPressed: () => _openBottomSheetMenu(context),
        child: Text(
          outcomeStatisticType,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
