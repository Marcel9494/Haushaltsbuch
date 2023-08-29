import 'package:flutter/material.dart';

import '/models/percentage_stats.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class CategoriePercentageCard extends StatelessWidget {
  final PercentageStats percentageStats;
  final DateTime? selectedDate;

  const CategoriePercentageCard({
    Key? key,
    required this.percentageStats,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
          child: ListTileTheme(
            contentPadding: const EdgeInsets.only(left: 12.0, right: 8.0),
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0.0,
            child: ExpansionTile(
              title: const SizedBox.shrink(),
              controlAffinity: ListTileControlAffinity.leading,
              textColor: Colors.cyanAccent,
              iconColor: Colors.cyanAccent,
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${percentageStats.percentage.abs().toStringAsFixed(1).replaceAll('.', ',')} %\t\t${percentageStats.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 12.0),
                      child: Text(
                        formatToMoneyAmount(formatMoneyAmountToDouble(percentageStats.amount).abs().toString()),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.bar_chart_rounded),
                      onPressed: () => Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(selectedDate!, percentageStats.name)),
                      padding: const EdgeInsets.only(right: 6.0),
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                SizedBox(
                  height: 2 * 58.0,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int subcategorieIndex) {
                      return ListTile(
                        title: Text('Test ' + subcategorieIndex.toString()),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.edit, color: Colors.white70),
                                onPressed: () => {},
                                //onPressed: () => Navigator.pushNamed(context, createOrEditSubcategorieRoute,
                                //    arguments: CreateOrEditSubcategorieScreenArguments(widget.categorie, ModeType.editMode, subcategorieIndex)),
                              ),
                              IconButton(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.remove_rounded, color: Colors.white70),
                                onPressed: () => {},
                                //onPressed: () => _deleteSubcategorie(subcategorieIndex),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
