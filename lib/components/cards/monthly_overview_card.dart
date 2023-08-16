import 'package:flutter/material.dart';

import '/models/monthly_stats.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class MonthlyOverviewCard extends StatelessWidget {
  final MonthlyStats monthlyStats;
  final int selectedYear;

  const MonthlyOverviewCard({
    Key? key,
    required this.monthlyStats,
    required this.selectedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: dateFormatterMMMM.format(DateTime.now()) == monthlyStats.month && DateTime.now().year == selectedYear
                  ? const Border(left: BorderSide(color: Colors.cyanAccent, width: 5.0))
                  : Border(
                      left:
                          BorderSide(color: monthlyStats.revenues - monthlyStats.expenditures - monthlyStats.investments >= 0 ? Colors.greenAccent : Colors.redAccent, width: 5.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        monthlyStats.month,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: dateFormatterMMMM.format(DateTime.now()) == monthlyStats.month && DateTime.now().year == selectedYear ? FontWeight.bold : FontWeight.normal,
                          color: dateFormatterMMMM.format(DateTime.now()) == monthlyStats.month && DateTime.now().year == selectedYear ? Colors.cyanAccent : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey.shade700, width: 0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatToMoneyAmount(monthlyStats.revenues.toString()), style: const TextStyle(color: Colors.greenAccent)),
                                  const Text(' - '),
                                  Text(formatToMoneyAmount(monthlyStats.expenditures.toString()), style: const TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(''),
                                  const Text('Saldo:  '),
                                  Text(formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures).toString()),
                                      style: TextStyle(color: monthlyStats.revenues - monthlyStats.expenditures >= 0.0 ? Colors.greenAccent : Colors.redAccent)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures).toString()),
                                      style: TextStyle(color: monthlyStats.revenues - monthlyStats.expenditures >= 0.0 ? Colors.greenAccent : Colors.redAccent)),
                                  const Text(' - '),
                                  Text(formatToMoneyAmount(monthlyStats.investments.toString()), style: const TextStyle(color: Colors.cyanAccent)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(''),
                                const Text('Verfügbar:  '),
                                Text(formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures - monthlyStats.investments).toString()),
                                    style: TextStyle(color: monthlyStats.revenues - monthlyStats.expenditures >= 0.0 ? Colors.greenAccent : Colors.redAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
