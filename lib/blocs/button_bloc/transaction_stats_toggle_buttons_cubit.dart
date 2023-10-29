import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '/models/enums/transaction_types.dart';

part 'transaction_stats_toggle_buttons_state.dart';

class TransactionStatsToggleButtonsCubit extends Cubit<TransactionStatsToggleButtonsState> {
  TransactionStatsToggleButtonsCubit()
      : super(TransactionStatsToggleButtonsState(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));

  void initTransaction() {
    emit(TransactionStatsToggleButtonsState(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
  }

  // TODO Werte die in Cubit abgespeichert wurden in create_or_edit_boking_screen auslesen und verwenden.
  void setSelectedTransaction(int selectedIndex, List<bool> selectedTransaction) {
    for (int i = 0; i < selectedTransaction.length; i++) {
      selectedTransaction[i] = i == selectedIndex;
    }
    if (selectedTransaction[0]) {
      emit(TransactionStatsToggleButtonsState(TransactionType.income.name, [true, false, false, false], Colors.greenAccent, Colors.greenAccent.withOpacity(0.2)));
    } else if (selectedTransaction[1]) {
      emit(TransactionStatsToggleButtonsState(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    } else if (selectedTransaction[2]) {
      emit(TransactionStatsToggleButtonsState(TransactionType.transfer.name, [false, false, true, false], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else if (selectedTransaction[3]) {
      emit(TransactionStatsToggleButtonsState(TransactionType.investment.name, [false, false, false, true], Colors.cyanAccent, Colors.cyanAccent.withOpacity(0.2)));
    } else {
      emit(TransactionStatsToggleButtonsState(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
    }
  }
}
