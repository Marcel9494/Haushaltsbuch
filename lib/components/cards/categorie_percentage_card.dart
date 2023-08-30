import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '/models/categorie.dart';
import '/models/percentage_stats.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class CategoriePercentageCard extends StatefulWidget {
  final PercentageStats percentageStats;
  final DateTime? selectedDate;

  const CategoriePercentageCard({
    Key? key,
    required this.percentageStats,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<CategoriePercentageCard> createState() => _CategoriePercentageCardState();
}

class _CategoriePercentageCardState extends State<CategoriePercentageCard> {
  List<String> _subcategorieNames = [];
  List<Booking> _subcategorieBookings = [];
  List<double> _subCategorieAmounts = [];

  // TODO hier weitermachen und Unterkategorie % Werte berechnen und Code verbessern! Nicht sehr performant aktuell
  Future<List<String>> _loadSubcategorieNameList() async {
    _subcategorieNames = await Categorie.loadSubcategorieNames(widget.percentageStats.name);
    for (int i = 0; i < _subcategorieNames.length; i++) {
      double totalAmount = 0.0;
      _subcategorieBookings = await Booking.loadSubcategorieBookingList(widget.selectedDate!.month, widget.selectedDate!.year, _subcategorieNames[i]);
      for (int j = 0; j < _subcategorieBookings.length; j++) {
        totalAmount += formatMoneyAmountToDouble(_subcategorieBookings[j].amount);
      }
      _subCategorieAmounts.add(totalAmount);
    }
    return _subcategorieNames;
  }

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
            border: Border(left: BorderSide(color: widget.percentageStats.statColor, width: 6.0)),
          ),
          child: ListTileTheme(
            contentPadding: const EdgeInsets.only(left: 8.0),
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0.0,
            child: ExpansionTile(
              title: const SizedBox.shrink(),
              // TODO hier weitermachen
              //trailing: const SizedBox.shrink(),
              //controlAffinity: ListTileControlAffinity.trailing,
              controlAffinity: ListTileControlAffinity.leading,
              textColor: widget.percentageStats.statColor,
              iconColor: widget.percentageStats.statColor,
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${widget.percentageStats.percentage.abs().toStringAsFixed(1).replaceAll('.', ',')} %\t\t${widget.percentageStats.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        formatToMoneyAmount(formatMoneyAmountToDouble(widget.percentageStats.amount).abs().toString()),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.bar_chart_rounded),
                      onPressed: () =>
                          Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(widget.selectedDate!, widget.percentageStats.name)),
                      padding: const EdgeInsets.only(right: 6.0),
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                FutureBuilder(
                  future: _loadSubcategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        return SizedBox(
                          height: _subcategorieNames.length * 58.0,
                          child: ListView.builder(
                            itemCount: _subcategorieNames.length,
                            itemBuilder: (BuildContext context, int subcategorieIndex) {
                              return ListTile(
                                title: Text(_subcategorieNames[subcategorieIndex] + ' ' + formatToMoneyAmount(_subCategorieAmounts[subcategorieIndex].toString())),
                              );
                            },
                          ),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
