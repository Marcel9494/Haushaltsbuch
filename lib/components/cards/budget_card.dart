import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/models/budget.dart';
import '/models/subbudget.dart';
import '/models/categorie.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class BudgetCard extends StatefulWidget {
  final Budget budget;
  final DateTime selectedDate;

  const BudgetCard({
    Key? key,
    required this.budget,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  List<String> _subcategorieNames = [];
  List<Subbudget> _subcategorieBudgets = [];
  final List<double> _subcategorieAmounts = [];
  final List<double> _subcategoriePercentages = [];

  Future<List<String>> _loadSubcategorieNameList() async {
    // TODO hier weitermachen Beispiel an categorie_percentage_card.dart -> _loadSubcategorieNameList nehmen
    _subcategorieNames = await Categorie.loadSubcategorieNames(widget.budget.categorie);
    for (int i = 0; i < _subcategorieNames.length; i++) {
      double totalAmount = 0.0;
      _subcategorieBudgets = await Subbudget.loadSubcategorieBudgetList(widget.budget.categorie, _subcategorieNames, widget.selectedDate);
      print(_subcategorieBudgets);
      /*for (int j = 0; j < _subcategorieBudgets.length; j++) {
        totalAmount += formatMoneyAmountToDouble(_subcategorieBookings[j].amount);
      }*/
      _subcategorieAmounts.add(totalAmount);
    }
    //double totalExpenditures = Booking.getExpenditures(widget.bookingList);
    for (int i = 0; i < _subcategorieNames.length; i++) {
      _subcategoriePercentages.add((_subcategorieAmounts[i] * 100) / 0.0); //totalExpenditures);
    }
    return _subcategorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(widget.selectedDate, widget.budget.categorie)),
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
              border: Border(
                left: BorderSide(
                    color: widget.budget.percentage < 80.0
                        ? Colors.greenAccent
                        : widget.budget.percentage < 100.0
                            ? Colors.yellowAccent.shade700
                            : Colors.redAccent,
                    width: 6.0),
              ),
            ),
            child: ListTileTheme(
              contentPadding: const EdgeInsets.only(left: 8.0),
              horizontalTitleGap: 0.0,
              minLeadingWidth: 0.0,
              child: ExpansionTile(
                title: const SizedBox.shrink(),
                controlAffinity: ListTileControlAffinity.leading,
                textColor: Colors.white,
                iconColor: Colors.white,
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(right: BorderSide(color: Colors.grey.shade700, width: 0.5)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 14.0, bottom: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.budget.categorie, overflow: TextOverflow.ellipsis, maxLines: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(formatToMoneyAmount(widget.budget.budget.toString()), overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatToMoneyAmount((widget.budget.budget - widget.budget.currentExpenditure).abs().toString()), overflow: TextOverflow.ellipsis),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: widget.budget.budget - widget.budget.currentExpenditure >= 0.0
                                        ? const Text('noch verfügbar', style: TextStyle(color: Colors.grey))
                                        : const Text('überschritten', style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      child: CircularPercentIndicator(
                        radius: 26.0,
                        lineWidth: 5.0,
                        percent: widget.budget.percentage / 100 >= 1.0 ? 1.0 : widget.budget.percentage / 100,
                        center: Text('${widget.budget.percentage.toStringAsFixed(0)} %', style: const TextStyle(fontSize: 12.0)),
                        progressColor: widget.budget.percentage < 80.0
                            ? Colors.greenAccent
                            : widget.budget.percentage < 100.0
                                ? Colors.yellowAccent.shade700
                                : Colors.redAccent,
                        backgroundWidth: 2.2,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animateFromLastPercent: true,
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int subcategorieIndex) {
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 36.0, right: 8.0),
                                        child: Text(
                                          _subcategorieNames[subcategorieIndex],
                                          style: const TextStyle(fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 52.0),
                                        child: Text(
                                          formatToMoneyAmount(_subcategorieAmounts[subcategorieIndex].toString()),
                                          style: const TextStyle(fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
