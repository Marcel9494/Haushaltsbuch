part of 'transaction_stats_toggle_buttons_cubit.dart';

abstract class TransactionStatsToggleButtonsState {}

class TransactionStatsToggleButtonsInitialState extends TransactionStatsToggleButtonsState {
  List<bool> selectedTransaction;
  TransactionStatsToggleButtonsInitialState(this.selectedTransaction);
}

class TransactionStatsToggleButtonsSuccessState extends TransactionStatsToggleButtonsState {
  List<bool> selectedTransaction;
  TransactionStatsToggleButtonsSuccessState(this.selectedTransaction);
}
