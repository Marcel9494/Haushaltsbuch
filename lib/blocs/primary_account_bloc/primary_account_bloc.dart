import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haushaltsbuch/blocs/input_field_blocs/preselect_account_input_field_bloc/preselect_account_input_field_cubit.dart';
import 'package:meta/meta.dart';

import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/models/primary_account/primary_account_model.dart';
import '/models/primary_account/primary_account_repository.dart';

part 'primary_account_event.dart';
part 'primary_account_state.dart';

class PrimaryAccountBloc extends Bloc<PrimaryAccountEvent, PrimaryAccountState> {
  PrimaryAccountBloc() : super(PrimaryAccountInitial()) {
    on<LoadPrimaryAccountEvent>((event, emit) async {
      emit(PrimaryAccountLoading());
      PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
      List<PrimaryAccount> loadedPrimaryAccounts = await primaryAccountRepository.loadPrimaryAccountList();
      TextInputFieldCubit accountNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
      PreselectAccountInputFieldCubit preselectAccountInputFieldCubit = BlocProvider.of<PreselectAccountInputFieldCubit>(event.context);
      String loadedTransactionTypes = "";
      // TODO hier weitermachen und Formatierung noch richtig implementieren
      for (int i = 0; i < loadedPrimaryAccounts.length; i++) {
        if (loadedPrimaryAccounts[i].accountName == accountNameInputFieldCubit.state.text) {
          loadedTransactionTypes += loadedPrimaryAccounts[i].transactionType + ', ';
        }
      }
      preselectAccountInputFieldCubit.updateValue(loadedTransactionTypes);
      emit(PrimaryAccountLoaded(loadedPrimaryAccounts));
    });

    on<SavePrimaryAccountEvent>((event, emit) async {
      PreselectAccountInputFieldCubit preselectAccountInputFieldCubit = BlocProvider.of<PreselectAccountInputFieldCubit>(event.context);
      PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
      primaryAccountRepository.setPrimaryAccountNames(preselectAccountInputFieldCubit.state.preselectedAccount, event.accountName);
      /*PrimaryAccount primaryAccount = PrimaryAccount()
        ..accountName = event.accountName
        ..transactionType = preselectAccountInputFieldCubit.state.preselectedAccount;
      primaryAccountRepository.create(primaryAccount);*/
    });
  }
}
