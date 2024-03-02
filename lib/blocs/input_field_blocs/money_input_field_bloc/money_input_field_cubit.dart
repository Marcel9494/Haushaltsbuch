import 'package:bloc/bloc.dart';

import '/models/enums/amount_types.dart';

part 'money_input_field_model.dart';

class MoneyInputFieldCubit extends Cubit<MoneyInputFieldModel> {
  MoneyInputFieldCubit() : super(MoneyInputFieldModel("", AmountType.notDefined.name, ""));
  void updateAmount(String newAmount) => emit(MoneyInputFieldModel(newAmount, state.amountType, ""));
  void updateAmountType(String newAmountType) => emit(MoneyInputFieldModel(state.amount, newAmountType, ""));
  void resetValue() => emit(MoneyInputFieldModel("", AmountType.notDefined.name, ""));
  void resetAmount() => emit(MoneyInputFieldModel("", state.amountType, ""));
  void resetAmountType() => emit(MoneyInputFieldModel(state.amount, AmountType.notDefined.name, ""));
  bool validateValue(String amount) {
    if (amount.isEmpty) {
      emit(MoneyInputFieldModel(amount, state.amountType, "Bitte geben Sie einen Betrag ein."));
      return false;
    }
    return true;
  }
}
