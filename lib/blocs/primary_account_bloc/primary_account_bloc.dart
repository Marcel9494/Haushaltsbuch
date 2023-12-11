import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

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
      emit(PrimaryAccountLoaded(loadedPrimaryAccounts));
    });
  }
}
