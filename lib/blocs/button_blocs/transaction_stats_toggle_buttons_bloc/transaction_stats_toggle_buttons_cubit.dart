import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../../input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/models/enums/transaction_types.dart';

part 'transaction_stats_toggle_buttons_model.dart';

class TransactionStatsToggleButtonsCubit extends Cubit<TransactionStatsToggleButtonsModel> {
  TransactionStatsToggleButtonsCubit()
      : super(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));

  void initTransaction() {
    emit(TransactionStatsToggleButtonsModel(TransactionType.outcome.name, [false, true, false, false], Colors.redAccent, Colors.redAccent.withOpacity(0.2)));
  }

  void setSelectedTransaction(int selectedIndex, List<bool> selectedTransaction, BuildContext context) {
    BlocProvider.of<MoneyInputFieldCubit>(context).resetAmountType();
    BlocProvider.of<CategorieInputFieldCubit>(context).resetValue();
    BlocProvider.of<SubcategorieInputFieldCubit>(context).resetValue();
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
