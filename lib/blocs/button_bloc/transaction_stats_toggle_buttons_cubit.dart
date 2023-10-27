import 'package:bloc/bloc.dart';
import '/models/enums/transaction_types.dart';

class TransactionStatsToggleButtonsCubit extends Cubit<String> {
  TransactionStatsToggleButtonsCubit() : super(TransactionType.outcome.name);
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");

  // TODO hier weitermachen und weitere Funktionen von transaction_toggle_buttons in Cubit verlagern.
  // TODO Danach Werte die in Cubit abgespeichert wurden in create_or_edit_bboking_screen auslesen und verwenden.
  void setSelectedTransaction(int selectedIndex, List<bool> selectedTransaction) {
    for (int i = 0; i < selectedTransaction.length; i++) {
      selectedTransaction[i] = i == selectedIndex;
    }
    if (selectedTransaction[0]) {
      emit(TransactionType.income.name);
    } else if (selectedTransaction[1]) {
      emit(TransactionType.outcome.name);
    } else if (selectedTransaction[2]) {
      emit(TransactionType.transfer.name);
    } else if (selectedTransaction[3]) {
      emit(TransactionType.investment.name);
    } else {
      resetValue();
    }
  }
}
