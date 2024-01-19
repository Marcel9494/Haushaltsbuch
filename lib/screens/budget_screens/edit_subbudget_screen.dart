import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/subbudget_bloc/subbudget_bloc.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '/blocs/input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/subcategorie_input_field.dart';

class EditSubbudgetScreen extends StatefulWidget {
  const EditSubbudgetScreen({Key? key}) : super(key: key);

  @override
  State<EditSubbudgetScreen> createState() => _EditSubbudgetScreenState();
}

class _EditSubbudgetScreenState extends State<EditSubbudgetScreen> {
  late final SubbudgetBloc subbudgetBloc;

  late final SubcategorieInputFieldCubit subcategorieInputFieldCubit;
  late final MoneyInputFieldCubit moneyInputFieldCubit;

  FocusNode subcategorieFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    subbudgetBloc = BlocProvider.of<SubbudgetBloc>(context);
    subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(context);
    moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unterbudget bearbeiten'),
        ),
        body: BlocBuilder<SubbudgetBloc, SubbudgetState>(
          builder: (context, budgetState) {
            if (budgetState is SubbudgetLoadingState) {
              return const LoadingIndicator();
            } else if (budgetState is SubbudgetLoadedState) {
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
                          return SubcategorieInputField(
                            cubit: subcategorieInputFieldCubit,
                            focusNode: subcategorieFocusNode,
                          );
                        },
                      ),
                      BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                        builder: (context, state) {
                          return MoneyInputField(cubit: moneyInputFieldCubit, focusNode: amountFocusNode, hintText: 'Budget', bottomSheetTitle: 'Budget eingeben:');
                        },
                      ),
                      SaveButton(
                          saveFunction: () => subbudgetBloc.add(UpdateSubbudgetEvent(context, budgetState.subbudgetBoxIndex, _saveButtonController)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              );
            } else {
              return const Text("Fehler bei Unterbudget editieren Seite");
            }
          },
        ),
      ),
    );
  }
}
