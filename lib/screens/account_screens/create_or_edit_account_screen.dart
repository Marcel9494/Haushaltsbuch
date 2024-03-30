import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/account_bloc/account_bloc.dart';
import '/blocs/primary_account_bloc/primary_account_bloc.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/account_type_input_field_bloc/account_type_input_field_cubit.dart';
import '/blocs/input_field_blocs/preselect_account_input_field_bloc/preselect_account_input_field_cubit.dart';

import '/components/deco/loading_indicator.dart';
import '/components/input_fields/account_type_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/buttons/save_button.dart';

class CreateOrEditAccountScreen extends StatefulWidget {
  const CreateOrEditAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditAccountScreen> createState() => _CreateOrEditAccountScreenState();
}

class _CreateOrEditAccountScreenState extends State<CreateOrEditAccountScreen> {
  late final AccountBloc accountBloc;

  late final AccountTypeInputFieldCubit accountTypeInputFieldCubit;
  late final TextInputFieldCubit accountNameInputFieldCubit;
  late final MoneyInputFieldCubit accountBalanceInputFieldCubit;
  late final PreselectAccountInputFieldCubit preselectedAccountInputFieldCubit;
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();

  UniqueKey accountNameFieldUniqueKey = UniqueKey();

  FocusNode accountTypeFocusNode = FocusNode();
  FocusNode accountNameFocusNode = FocusNode();
  FocusNode accountBalanceFocusNode = FocusNode();
  FocusNode preselectedAccountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    BlocProvider.of<PrimaryAccountBloc>(context).add(LoadPrimaryAccountEvent(context));
    accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(context);
    accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
    preselectedAccountInputFieldCubit = BlocProvider.of<PreselectAccountInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          if (accountState is AccountLoadingState) {
            return const LoadingIndicator();
          } else if (accountState is AccountLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: accountState.accountBoxIndex == -1 ? const Text('Konto erstellen') : const Text('Konto bearbeiten'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<AccountTypeInputFieldCubit, AccountTypeInputFieldModel>(
                        builder: (context, state) {
                          return AccountTypeInputField(cubit: accountTypeInputFieldCubit, focusNode: accountTypeFocusNode);
                        },
                      ),
                      BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                        builder: (context, state) {
                          return TextInputField(fieldKey: accountNameFieldUniqueKey, focusNode: accountNameFocusNode, textCubit: accountNameInputFieldCubit, hintText: 'Name');
                        },
                      ),
                      BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                        builder: (context, state) {
                          if (accountState.accountBoxIndex == -1) accountBalanceInputFieldCubit.state.amount = '0,00 €';
                          return MoneyInputField(
                              focusNode: accountBalanceFocusNode, cubit: accountBalanceInputFieldCubit, hintText: 'Kontostand', bottomSheetTitle: 'Kontostand eingeben:');
                        },
                      ),
                      /* TODO muss noch implementiert werden BlocBuilder<PreselectAccountInputFieldCubit, PreselectAccountInputFieldModel>(
                        builder: (context, state) {
                          return PreselectAccountInputField(cubit: preselectedAccountInputFieldCubit, focusNode: preselectedAccountFocusNode);
                        },
                      ),*/
                      SaveButton(
                          saveFunction: () => accountBloc.add(CreateOrUpdateAccountEvent(context, accountState.accountBoxIndex, _saveButtonController)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Kontoseite");
          }
        },
      ),
    );
  }
}
