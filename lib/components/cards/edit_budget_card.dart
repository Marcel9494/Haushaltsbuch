import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/budget_bloc/budget_bloc.dart';
import '/blocs/subbudget_bloc/subbudget_bloc.dart';

import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/budget/budget_model.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';

class EditBudgetCard extends StatefulWidget {
  final Budget budget;

  const EditBudgetCard({
    Key? key,
    required this.budget,
  }) : super(key: key);

  @override
  State<EditBudgetCard> createState() => _EditBudgetCardState();
}

class _EditBudgetCardState extends State<EditBudgetCard> {
  List<Subbudget> _subbudgets = [];
  String allSubcategorieNames = "";

  Future<void> _loadSubcategories() async {
    SubbudgetRepository subbudgetRepository = SubbudgetRepository();
    _subbudgets = await subbudgetRepository.loadSubcategorieList(widget.budget.categorie);
  }

  String _getSubcategorieNames(List<Subbudget> subcategories) {
    for (int i = 0; i < subcategories.length; i++) {
      allSubcategorieNames += i == 0 ? _subbudgets[i].subcategorieName : " · " + _subbudgets[i].subcategorieName;
    }
    return allSubcategorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.only(left: 8.0),
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0.0,
        child: FutureBuilder(
          future: _loadSubcategories(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.done:
                return ExpansionTile(
                  leading: const SizedBox.shrink(),
                  controlAffinity: ListTileControlAffinity.leading,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  shape: const Border(),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  widget.budget.categorie,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ),
                              _subbudgets.isEmpty
                                  ? const Text('-', style: TextStyle(fontSize: 12.0, color: Colors.grey))
                                  : Text(
                                      _getSubcategorieNames(_subbudgets),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          formatToMoneyAmount(widget.budget.budget.toString()),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Colors.white),
                          onPressed: () =>
                              BlocProvider.of<BudgetBloc>(context).add(LoadBudgetListFromOneCategorieEvent(context, -1, widget.budget.categorie, DateTime.now().year, true)),
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    FutureBuilder(
                      future: _loadSubcategories(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const SizedBox();
                          case ConnectionState.done:
                            return SizedBox(
                              height: _subbudgets.length * 58.0,
                              child: ListView.builder(
                                itemCount: _subbudgets.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int subcategorieIndex) {
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20.0, right: 12.0),
                                            child: Text(
                                              _subbudgets[subcategorieIndex].subcategorieName,
                                              style: const TextStyle(fontSize: 14.0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            formatToMoneyAmount(_subbudgets[subcategorieIndex].subcategorieBudget.toString()),
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 14.0),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit_rounded),
                                            onPressed: () => BlocProvider.of<SubbudgetBloc>(context).add(
                                                LoadSubbudgetListFromOneCategorieEvent(context, -1, _subbudgets[subcategorieIndex].subcategorieName, DateTime.now().year, true)),
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
                );
              default:
                return const Text('Unbekannter Fehler bei Budget Karte aufgetreten.');
            }
          },
        ),
      ),
    ).animate().fade(duration: fadeAnimationInMs.ms);
  }
}
