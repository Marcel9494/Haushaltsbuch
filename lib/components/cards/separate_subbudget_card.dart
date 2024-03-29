import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/subbudget_bloc/subbudget_bloc.dart';

import '/models/subbudget/subbudget_model.dart';

import '/utils/consts/global_consts.dart';
import '/utils/date_formatters/date_formatter.dart';
import '/utils/number_formatters/number_formatter.dart';

class SeparateSubbudgetCard extends StatelessWidget {
  final Subbudget subbudget;

  const SeparateSubbudgetCard({
    Key? key,
    required this.subbudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlocProvider.of<SubbudgetBloc>(context)
          .add(LoadSubbudgetListFromOneCategorieEvent(context, subbudget.boxIndex, subbudget.categorie, DateTime.parse(subbudget.budgetDate).year, true)),
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
                      color: DateTime.parse(subbudget.budgetDate).month == DateTime.now().month && DateTime.parse(subbudget.budgetDate).year == DateTime.now().year
                          ? Colors.cyanAccent
                          : Colors.transparent,
                      width: 3.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DateTime.parse(subbudget.budgetDate).month == DateTime.now().month && DateTime.parse(subbudget.budgetDate).year == DateTime.now().year
                                ? Colors.cyanAccent
                                : Colors.blueGrey)),
                    child: dateFormatterMMMM.format(DateTime.parse(subbudget.budgetDate)).length > 3
                        ? Text('${dateFormatterMMM.format(DateTime.parse(subbudget.budgetDate))}.')
                        : Text(dateFormatterMMM.format(DateTime.parse(subbudget.budgetDate))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(formatToMoneyAmount(subbudget.subcategorieBudget.toString())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fade(duration: fadeAnimationInMs.ms),
    );
  }
}
