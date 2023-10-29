part of 'transaction_stats_toggle_buttons_cubit.dart';

class TransactionStatsToggleButtonsState {
  late String transactionName;
  late List<bool> selectedTransaction;
  late Color borderColor;
  late Color fillColor;

  TransactionStatsToggleButtonsState(this.transactionName, this.selectedTransaction, this.borderColor, this.fillColor);
}
