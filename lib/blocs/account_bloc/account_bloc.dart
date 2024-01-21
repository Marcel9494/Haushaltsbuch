import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/primary_account_bloc/primary_account_bloc.dart';
import '/blocs/input_field_blocs/preselect_account_input_field_bloc/preselect_account_input_field_cubit.dart';

import '/components/dialogs/choice_dialog.dart';

import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';
import '/models/enums/repeat_types.dart';
import '/models/account/account_model.dart';
import '/models/enums/transaction_types.dart';
import '/models/account/account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import '../input_field_blocs/account_type_input_field_bloc/account_type_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountRepository accountRepository = AccountRepository();
  BookingRepository bookingRepository = BookingRepository();
  Account savedAccount = Account();

  void onPress(BuildContext context, bool recordBooking) {
    AccountTypeInputFieldCubit accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(context);
    TextInputFieldCubit accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    MoneyInputFieldCubit accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
    String transactionType = '';
    double newBankBalance = 0.0;
    double difference = (formatMoneyAmountToDouble(savedAccount.bankBalance) - formatMoneyAmountToDouble(accountBalanceInputFieldCubit.state.amount)).abs();
    if (formatMoneyAmountToDouble(savedAccount.bankBalance) >= formatMoneyAmountToDouble(accountBalanceInputFieldCubit.state.amount)) {
      newBankBalance = formatMoneyAmountToDouble(accountBalanceInputFieldCubit.state.amount) + difference;
      transactionType = TransactionType.outcome.name;
    } else {
      newBankBalance = formatMoneyAmountToDouble(accountBalanceInputFieldCubit.state.amount) - difference;
      transactionType = TransactionType.income.name;
    }
    if (recordBooking) {
      Booking newBooking = Booking()
        ..transactionType = transactionType
        ..bookingRepeats = RepeatType.noRepetition.name
        ..title = 'Betrag Änderung'
        ..date = DateTime.now().toString()
        ..amount = formatToMoneyAmount(difference.toString())
        ..categorie = 'Differenz'
        ..subcategorie = ''
        ..fromAccount = accountNameInputFieldCubit.state.text
        ..toAccount = accountNameInputFieldCubit.state.text
        ..serieId = -1
        ..booked = true;
      bookingRepository.create(newBooking);
    } else {
      accountRepository.calculateNewAccountBalance(accountNameInputFieldCubit.state.text, formatToMoneyAmount(difference.toString()), transactionType);
    }
    Account updatedAccount = Account()
      ..boxIndex = savedAccount.boxIndex
      ..accountType = accountTypeInputFieldCubit.state.accountType
      ..bankBalance = formatToMoneyAmount(newBankBalance.toString())
      ..name = accountNameInputFieldCubit.state.text;
    accountRepository.update(updatedAccount, savedAccount.boxIndex, savedAccount.name);
    for (int i = 0; i < 4; i++) {
      Navigator.pop(context);
    }
    Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
  }

  AccountBloc() : super(AccountInitial()) {
    on<CreateOrLoadAccountEvent>((event, emit) async {
      emit(AccountLoadingState());
      AccountTypeInputFieldCubit accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(event.context);
      TextInputFieldCubit accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
      MoneyInputFieldCubit accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      PreselectAccountInputFieldCubit preselectAccountInputFieldCubit = BlocProvider.of<PreselectAccountInputFieldCubit>(event.context);

      accountTypeInputFieldCubit.resetValue();
      accountNameInputFieldCubit.resetValue();
      accountBalanceInputFieldCubit.resetValue();
      preselectAccountInputFieldCubit.resetValue();

      if (event.accountBoxIndex != -1) {
        Account loadedAccount = await accountRepository.load(event.accountBoxIndex);
        accountTypeInputFieldCubit.updateValue(loadedAccount.accountType);
        accountNameInputFieldCubit.updateValue(loadedAccount.name);
        accountBalanceInputFieldCubit.updateValue(loadedAccount.bankBalance);
        // TODO preselectAccountInputFieldCubit.updateValue(loadedAccount.)

        savedAccount.boxIndex = event.accountBoxIndex;
        savedAccount.bankBalance = accountBalanceInputFieldCubit.state.amount;
        savedAccount.name = accountNameInputFieldCubit.state.text;
        savedAccount.accountType = accountTypeInputFieldCubit.state.accountType;
      }
      Navigator.pushNamed(event.context, createOrEditAccountRoute);
      emit(AccountLoadedState(event.context, event.accountBoxIndex));
    });

    on<CreateOrUpdateAccountEvent>((event, emit) async {
      AccountTypeInputFieldCubit accountTypeInputFieldCubit = BlocProvider.of<AccountTypeInputFieldCubit>(event.context);
      TextInputFieldCubit accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
      MoneyInputFieldCubit accountBalanceInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      if (accountTypeInputFieldCubit.validateValue(accountTypeInputFieldCubit.state.accountType) == false ||
          accountNameInputFieldCubit.validateValue(accountNameInputFieldCubit.state.text) == false ||
          accountBalanceInputFieldCubit.validateValue(accountBalanceInputFieldCubit.state.amount) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      }
      Account account = Account();
      if (event.accountBoxIndex == -1) {
        account = Account()
          ..accountType = accountTypeInputFieldCubit.state.accountType
          ..bankBalance = accountBalanceInputFieldCubit.state.amount
          ..name = accountNameInputFieldCubit.state.text;
        accountRepository.create(account);
      } else {
        if (savedAccount.bankBalance != accountBalanceInputFieldCubit.state.amount) {
          showChoiceDialog(
              event.context,
              'Buchung erfassen?',
              () => onPress(event.context, true),
              () => onPress(event.context, false),
              'Buchung wurde erstellt',
              'Buchung wurde erfolgreich erstellt.',
              Icons.info_outline,
              'Der Betragsunterschied wurde in deinem Account gespeichert. Möchtest du die Differenz als ${formatMoneyAmountToDouble(savedAccount.bankBalance) >= formatMoneyAmountToDouble(accountBalanceInputFieldCubit.state.amount) ? TransactionType.outcome.name : TransactionType.income.name} erfassen?');
          return;
        } else {
          account = Account()
            ..boxIndex = event.accountBoxIndex
            ..accountType = accountTypeInputFieldCubit.state.accountType
            ..bankBalance = accountBalanceInputFieldCubit.state.amount
            ..name = accountNameInputFieldCubit.state.text;
          accountRepository.update(account, event.accountBoxIndex, savedAccount.name);
        }
      }
      PrimaryAccountBloc primaryAccountBloc = BlocProvider.of<PrimaryAccountBloc>(event.context);
      primaryAccountBloc.add(SavePrimaryAccountEvent(event.context, account.name, account.accountType));

      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
    });
  }
}
