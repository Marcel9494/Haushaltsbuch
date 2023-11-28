part of 'transaction_stats_toggle_buttons_cubit.dart';

class TransactionStatsToggleButtonsModel {
  late String transactionName;
  late List<bool> selectedTransaction;
  late Color borderColor;
  late Color fillColor;

  TransactionStatsToggleButtonsModel(this.transactionName, this.selectedTransaction, this.borderColor, this.fillColor);
}
