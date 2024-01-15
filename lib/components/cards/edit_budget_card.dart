import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/budget_bloc/budget_bloc.dart';
import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '/models/budget/budget_model.dart';
import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_repository.dart';
import '/models/screen_arguments/edit_budget_screen_arguments.dart';
import '/models/screen_arguments/edit_subbudget_screen_arguments.dart';

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

  Future<void> _loadSubcategories() async {
    SubbudgetRepository subbudgetRepository = SubbudgetRepository();
    _subbudgets = await subbudgetRepository.loadSubcategorieList(widget.budget.categorie);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const SizedBox.shrink(),
          controlAffinity: ListTileControlAffinity.leading,
          textColor: Colors.white,
          iconColor: Colors.white,
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(widget.budget.categorie, overflow: TextOverflow.ellipsis),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(formatToMoneyAmount(widget.budget.budget.toString()), overflow: TextOverflow.ellipsis),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => BlocProvider.of<BudgetBloc>(context).add(LoadBudgetListFromOneCategorieEvent(context, -1, widget.budget.categorie, DateTime.now().year)),
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
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 74.0, right: 18.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _subbudgets[subcategorieIndex].subcategorieName,
                                          style: const TextStyle(fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    formatToMoneyAmount(_subbudgets[subcategorieIndex].subcategorieBudget.toString()),
                                    style: const TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_rounded),
                                    onPressed: () => Navigator.pushNamed(context, editSubbudgetRoute, arguments: EditSubbudgetScreenArguments(_subbudgets[subcategorieIndex])),
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
    );
  }
}
