import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '/models/enums/transaction_types.dart';

part 'transaction_stats_toggle_buttons_model.dart';

class TransactionStatsToggleButtonsCubit extends Cubit<TransactionStatsToggleButtonsModel> {
  TransactionStatsToggleButtonsCubit()
      : super(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));

  void initTransaction() {
    emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
  }

  void setSelectedTransaction(int selectedIndex, List<bool> selectedTransaction) {
    for (int i = 0; i < selectedTransaction.length; i++) {
      selectedTransaction[i] = i == selectedIndex;
    }
    if (selectedTransaction[0]) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.income.name, [true, false, false, false], Colors.greenAccent, Colors.greenAccent.withOpacity(0.2)));
    } else if (selectedTransaction[1]) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    } else if (selectedTransaction[2]) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.transfer.name, [false, false, true, false], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else if (selectedTransaction[3]) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.investment.name, [false, false, false, true], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else {
      emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    }
  }

  void updateTransactionType(String transactionType) {
    if (transactionType == TransactionType.income.name) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.income.name, [true, false, false, false], Colors.greenAccent, Colors.greenAccent.withOpacity(0.2)));
    } else if (transactionType == TransactionType.outcome.name) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    } else if (transactionType == TransactionType.transfer.name) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.transfer.name, [false, false, true, false], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else if (transactionType == TransactionType.investment.name) {
      emit(TransactionStatsToggleButtonsModel(TransactionType.investment.name, [false, false, false, true], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else {
      emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    }
  }
}
