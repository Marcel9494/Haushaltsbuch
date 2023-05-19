import 'package:flutter/material.dart';

import '/models/percentage_stats.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class PercentageCard extends StatelessWidget {
  final PercentageStats percentageStats;
  final DateTime? selectedDate;

  const PercentageCard({
    Key? key,
    required this.percentageStats,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(selectedDate!, percentageStats.name)),
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
                      '${percentageStats.percentage.toStringAsFixed(1).replaceAll('.', ',')} %\t\t${percentageStats.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                    child: Text(
                      percentageStats.amount,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
