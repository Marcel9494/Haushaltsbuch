import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/models/account/account_model.dart';
import '/models/account/account_repository.dart';

import '/utils/consts/route_consts.dart';

import '../input_field_blocs/account_type_input_field_bloc/account_type_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountRepository accountRepository = AccountRepository();

  AccountBloc() : super(AccountInitial()) {
    on<CreateOrLoadAccountEvent>((event, emit) async {
      emit(AccountLoadingState());
      AccountTypeInputFieldCubit accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(event.context);
      TextInputFieldCubit accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
      MoneyInputFieldCubit accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);

      accountTypeInputFieldCubit.resetValue();
      accountNameInputFieldCubit.resetValue();
      accountBalanceInputFieldCubit.resetValue();

      if (event.accountBoxIndex != -1) {
        Account loadedAccount = await accountRepository.load(event.accountBoxIndex);
        accountTypeInputFieldCubit.updateValue(loadedAccount.accountType);
        accountNameInputFieldCubit.updateValue(loadedAccount.name);
        accountBalanceInputFieldCubit.updateValue(loadedAccount.bankBalance);
      }
      Navigator.pushNamed(event.context, createOrEditAccountRoute);
      emit(AccountLoadedState(event.context, event.accountBoxIndex));
    });
    // TODO hier weitermachen und weitere Funktionalitäten von Konto in Bloc umziehen
  }
}
