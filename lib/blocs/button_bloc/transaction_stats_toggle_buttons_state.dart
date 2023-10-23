part of 'transaction_stats_toggle_buttons_cubit.dart';

@immutable
abstract class TransactionStatsToggleButtonsState {}

class TransactionStatsToggleButtonsInitial extends TransactionStatsToggleButtonsState {}

class TransactionStatsToggleButtonsSuccessState extends TransactionStatsToggleButtonsState {
  List<bool> selectedTransaction;
  TransactionStatsToggleButtonsSuccessState(this.selectedTransaction);
}
