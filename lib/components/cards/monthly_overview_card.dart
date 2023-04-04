import 'package:flutter/material.dart';

import '../../models/monthly_stats.dart';

import '../../utils/number_formatters/number_formatter.dart';

class MonthlyOverviewCard extends StatelessWidget {
  final MonthlyStats monthlyStats;

  const MonthlyOverviewCard({
    Key? key,
    required this.monthlyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: const Color(0xff1c2b30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.cyanAccent, width: 5.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.5)),
                      ),
                      child: Text(monthlyStats.month),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                formatToMoneyAmount(monthlyStats.revenues.toString()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.greenAccent),
                              ),
                              Text(
                                formatToMoneyAmount(monthlyStats.expenditures.toString()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                              Text(
                                formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures).toString()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.cyanAccent),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures).toString()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                            Text(
                              formatToMoneyAmount(monthlyStats.investments.toString()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            Text(
                              formatToMoneyAmount((monthlyStats.revenues - monthlyStats.expenditures - monthlyStats.investments).toStringAsFixed(2)),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.cyanAccent),
                            ),
                          ],
                        ),
                      ],
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
