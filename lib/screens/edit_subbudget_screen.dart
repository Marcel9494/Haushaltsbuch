import 'package:flutter/material.dart';

import '/models/subbudget.dart';
import '/models/default_budget.dart';

import '/utils/consts/route_consts.dart';

import '/components/dialogs/choice_dialog.dart';
import '/components/deco/loading_indicator.dart';
import '/components/cards/default_budget_card.dart';
import '/components/buttons/year_picker_buttons.dart';

class EditSubbudgetScreen extends StatefulWidget {
  final Subbudget subbudget;

  const EditSubbudgetScreen({
    Key? key,
    required this.subbudget,
  }) : super(key: key);

  @override
  State<EditSubbudgetScreen> createState() => _EditSubbudgetScreenState();
}

class _EditSubbudgetScreenState extends State<EditSubbudgetScreen> {
  List<Subbudget> _subbudgetList = [];
  // TODO hier weitermachen und überlegen, ob für Unterkategorie Budgets ebenfalls
  // TODO eine separate Standardbudgets Datenstruktur angelegt werden soll oder ob die
  // TODO bereits vorhandene Standardbudgets verwendet werden soll?
  // TODO Danach Unterkategorie Budgets laden und anzeigen lassen (neue Laden Funktionen implementieren)
  DefaultBudget _defaultBudget = DefaultBudget();
  DateTime _selectedYear = DateTime.now();

  Future<List<Subbudget>> _loadOneBudgetCategorie() async {
    _defaultBudget = await DefaultBudget.loadDefaultBudget(widget.subbudget.categorie);
    // TODO _subbudgetList = await Subbudget.loadOneBudgetCategorie(widget.subbudget.categorie, _selectedYear.year);
    return _subbudgetList;
  }

  void _deleteBudget() {
    showChoiceDialog(
        context, 'Budget löschen?', _yesPressed, _noPressed, 'Budget wurde gelöscht', 'Budget für ${widget.subbudget.categorie} wurde erfolgreich gelöscht.', Icons.info_outline);
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
            onPressed: () => _deleteBudget(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YearPickerButtons(selectedYear: _selectedYear, selectedYearCallback: (selectedYear) => setState(() => _selectedYear = selectedYear)),
          FutureBuilder(
            future: _loadOneBudgetCategorie(),
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
                              _subbudgetList = await _loadOneBudgetCategorie();
                              setState(() {});
                              return;
                            },
                            color: Colors.cyanAccent,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _subbudgetList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return const Text('TODO'); // TODO SeparateBudgetCard(budget: _subbudgetList[index]);
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
