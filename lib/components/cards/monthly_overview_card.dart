import 'package:flutter/material.dart';

import '../../models/monthly_stats.dart';

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
                  Text(monthlyStats.month),
                  Text(monthlyStats.revenues),
                  Text(monthlyStats.expenditures),
                  Text(monthlyStats.investments),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
