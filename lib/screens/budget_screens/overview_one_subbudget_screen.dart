import 'package:flutter/material.dart';

import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/default_budget/default_budget_model.dart';
import '/models/default_budget/default_budget_repository.dart';

import '/utils/consts/route_consts.dart';

import '/components/dialogs/choice_dialog.dart';
import '/components/deco/loading_indicator.dart';
import '/components/cards/default_budget_card.dart';
import '/components/buttons/year_picker_buttons.dart';
import '/components/cards/separate_subbudget_card.dart';

class OverviewOneSubbudgetScreen extends StatefulWidget {
  final Subbudget subbudget;

  const OverviewOneSubbudgetScreen({
    Key? key,
    required this.subbudget,
  }) : super(key: key);

  @override
  State<OverviewOneSubbudgetScreen> createState() => _OverviewOneSubbudgetScreenState();
}

class _OverviewOneSubbudgetScreenState extends State<OverviewOneSubbudgetScreen> {
  List<Subbudget> _subbudgetList = [];
  // TODO hier weitermachen und überlegen, ob für Unterkategorie Budgets ebenfalls
  // TODO eine separate Standardbudgets Datenstruktur angelegt werden soll oder ob die
  // TODO bereits vorhandene Standardbudgets verwendet werden soll? => Entscheidung: Bereits erstellte DefaultBudget Datenstruktur verwenden!
  // TODO Danach Unterkategorie Budgets laden und anzeigen lassen (neue Laden Funktionen implementieren)
  DefaultBudget _defaultBudget = DefaultBudget();
  DateTime _selectedYear = DateTime.now();

  Future<List<Subbudget>> _loadOneSubbudgetCategorie() async {
    SubbudgetRepository subbudgetRepository = SubbudgetRepository();
    DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
    _defaultBudget = await defaultBudgetRepository.load(widget.subbudget.subcategorieName);
    _subbudgetList = await subbudgetRepository.loadOneSubbudget(widget.subbudget.subcategorieName);
    return _subbudgetList;
  }

  void _deleteSubbudget() {
    showChoiceDialog(context, 'Budget löschen?', _yesPressed, _noPressed, 'Budget wurde gelöscht', 'Budget für ${widget.subbudget.subcategorieName} wurde erfolgreich gelöscht.',
        Icons.info_outline);
  }

  void _yesPressed() {
    setState(() {
      // TODO widget.subbudget.deleteAllBudgetsFromCategorie(widget.subbudget.categorie);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, overviewBudgetsRoute);
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _deleteSubbudget(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YearPickerButtons(selectedYear: _selectedYear, selectedYearCallback: (selectedYear) => setState(() => _selectedYear = selectedYear)),
          FutureBuilder(
            future: _loadOneSubbudgetCategorie(),
            builder: (BuildContext context, AsyncSnapshot<List<Subbudget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingIndicator();
                case ConnectionState.done:
                  if (_subbudgetList.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('Keine Budgets vorhanden'),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          DefaultBudgetCard(defaultBudget: _defaultBudget),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Divider(),
                          ),
                          RefreshIndicator(
                            onRefresh: () async {
                              _subbudgetList = await _loadOneSubbudgetCategorie();
                              setState(() {});
                              return;
                            },
                            color: Colors.cyanAccent,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _subbudgetList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SeparateSubbudgetCard(subbudget: _subbudgetList[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                default:
                  if (snapshot.hasError) {
                    return const Text('Budget Übersicht konnte nicht geladen werden.');
                  }
                  return const LoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
