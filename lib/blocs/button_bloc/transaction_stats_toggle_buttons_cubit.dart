import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/models/enums/transaction_types.dart';

part 'transaction_stats_toggle_buttons_state.dart';

// TODO hier weitermachen und TransactionToogleButtons zu Bloc umwandeln, weil ich hier einen
// komplexeren State setzen (emitten) muss + Success State implementieren mit List<bool> und
// in Toggle Button aufrufen mit BlocBuilder
class TransactionStatsToggleButtonsCubit extends Cubit<TransactionStatsToggleButtonsState> {
  TransactionStatsToggleButtonsCubit() : super(TransactionStatsToggleButtonsInitial());

  void updateValue(String currentTransaction) async {
    if (currentTransaction == TransactionType.income.name) {
      emit(<bool>[true, false, false, false]);
    } else if (currentTransaction == TransactionType.outcome.name) {
      _selectedTransaction = <bool>[false, true, false, false];
    } else if (currentTransaction == TransactionType.transfer.name) {
      _selectedTransaction = <bool>[false, false, true, false];
    } else if (currentTransaction == TransactionType.investment.name) {
      _selectedTransaction = <bool>[false, false, false, true];
    }
  }
}
