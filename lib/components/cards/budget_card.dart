import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/models/budget/budget_model.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/categorie/categorie_repository.dart';
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

  Future<List<String>> _loadSubcategorieBudgets() async {
    SubbudgetRepository subbudgetRepository = SubbudgetRepository();
    CategorieRepository categorieRepository = CategorieRepository();
    _subcategorieNames = await categorieRepository.loadSubcategorieNameList(widget.budget.categorie);
    _subcategorieBudgets = await subbudgetRepository.loadSubcategorieBudgetList(widget.budget.categorie, _subcategorieNames, widget.selectedDate);
    _subcategorieBudgets = await subbudgetRepository.calculateCurrentExpenditure(_subcategorieBudgets, widget.selectedDate);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0, right: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.budget.categorie +
                                ': ' +
                                formatToMoneyAmount(widget.budget.currentExpenditure.toString()) +
                                ' / ' +
                                formatToMoneyAmount(widget.budget.budget.toString())),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                width: 200.0,
                                lineHeight: 14.0,
                                percent: widget.budget.percentage / 100 >= 1.0 ? 1.0 : widget.budget.percentage / 100,
                                center: Text('${widget.budget.percentage.toStringAsFixed(0)} %',
                                    style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black87)),
                                progressColor: widget.budget.percentage < 80.0
                                    ? Colors.green
                                    : widget.budget.percentage < 100.0
                                        ? Colors.yellowAccent.shade700
                                        : Colors.redAccent,
                                barRadius: const Radius.circular(20.0),
                                animation: true,
                                animateFromLastPercent: true,
                                animationDuration: 1000,
                              ),
                            ),
                            Text(
                              widget.budget.percentage <= 100.0
                                  ? 'Du kannst noch ' +
                                      formatToMoneyAmount(((widget.budget.budget - widget.budget.currentExpenditure) /
                                              (DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 0).day - DateTime.now().day + 1))
                                          .toString()) +
                                      ' / Tag ausgeben'
                                  : 'Du hast das Budget um ' + formatToMoneyAmount((widget.budget.currentExpenditure - widget.budget.budget).toString()) + ' überzogen',
                              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.bar_chart_rounded,
                            size: 28.0,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(widget.selectedDate, widget.budget.categorie)),
                        ),
                      ),
                    ),
                  ],
                ),
                children: <Widget>[
                  FutureBuilder(
                    future: _loadSubcategorieBudgets(),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const SizedBox();
                        case ConnectionState.done:
                          return SizedBox(
                            height: _subcategorieBudgets.length * 80.0,
                            child: ListView.builder(
                              itemCount: _subcategorieBudgets.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int subcategorieIndex) {
                                return ListTile(
                                  subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 36.0, top: 4.0, bottom: 4.0, right: 4.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_subcategorieBudgets[subcategorieIndex].subcategorieName +
                                                ': ' +
                                                formatToMoneyAmount(_subcategorieBudgets[subcategorieIndex].currentSubcategorieExpenditure.toString()) +
                                                ' / ' +
                                                formatToMoneyAmount(_subcategorieBudgets[subcategorieIndex].subcategorieBudget.toString())),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: LinearPercentIndicator(
                                                padding: EdgeInsets.zero,
                                                width: 200.0,
                                                lineHeight: 14.0,
                                                percent: _subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage / 100 >= 1.0
                                                    ? 1.0
                                                    : _subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage / 100,
                                                center: Text('${_subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage.toStringAsFixed(0)} %',
                                                    style: const TextStyle(fontSize: 12.0, color: Colors.black87)),
                                                progressColor: _subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage < 80.0
                                                    ? Colors.green
                                                    : _subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage < 100.0
                                                        ? Colors.yellowAccent.shade700
                                                        : Colors.redAccent,
                                                barRadius: const Radius.circular(20.0),
                                                animation: true,
                                                animateFromLastPercent: true,
                                                animationDuration: 1000,
                                              ),
                                            ),
                                            Text(
                                              _subcategorieBudgets[subcategorieIndex].currentSubcategoriePercentage <= 100.0
                                                  ? 'Du kannst noch ' +
                                                      formatToMoneyAmount(((_subcategorieBudgets[subcategorieIndex].subcategorieBudget -
                                                                  _subcategorieBudgets[subcategorieIndex].currentSubcategorieExpenditure) /
                                                              (DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 0).day - DateTime.now().day + 1))
                                                          .toString()) +
                                                      ' / Tag ausgeben'
                                                  : 'Du hast dein Budget um ' +
                                                      formatToMoneyAmount((_subcategorieBudgets[subcategorieIndex].currentSubcategorieExpenditure -
                                                              _subcategorieBudgets[subcategorieIndex].subcategorieBudget)
                                                          .toString()) +
                                                      ' überschritten',
                                              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                                            ),
                                          ],
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
