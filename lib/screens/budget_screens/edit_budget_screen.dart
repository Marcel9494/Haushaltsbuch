import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/models/enums/categorie_types.dart';
import '/models/enums/transaction_types.dart';

import '/blocs/budget_bloc/budget_bloc.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';

import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/categorie_input_field.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({Key? key}) : super(key: key);

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  late final BudgetBloc budgetBloc;

  late final CategorieInputFieldCubit categorieInputFieldCubit;
  late final MoneyInputFieldCubit moneyInputFieldCubit;

  FocusNode categorieFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    budgetBloc = BlocProvider.of<BudgetBloc>(context);
    categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(context);
    moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budget bearbeiten'),
        ),
        body: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, budgetState) {
            if (budgetState is BudgetLoadingState) {
              return const LoadingIndicator();
            } else if (budgetState is BudgetLoadedState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<CategorieInputFieldCubit, CategorieInputFieldModel>(
                        builder: (context, state) {
                          return CategorieInputField(
                            cubit: categorieInputFieldCubit,
                            focusNode: categorieFocusNode,
                            categorieType: CategorieTypeExtension.getCategorieType(TransactionType.outcome.name),
                          );
                        },
                      ),
                      BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                        builder: (context, state) {
                          return MoneyInputField(cubit: moneyInputFieldCubit, focusNode: amountFocusNode, hintText: 'Budget', bottomSheetTitle: 'Budget eingeben:');
                        },
                      ),
                      SaveButton(
                          saveFunction: () => budgetBloc.add(UpdateBudgetEvent(context, budgetState.budgetBoxIndex, _saveButtonController)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              );
            } else {
              return const Text("Fehler bei Budget editieren Seite");
            }
          },
        ),
      ),
    );
  }
}
