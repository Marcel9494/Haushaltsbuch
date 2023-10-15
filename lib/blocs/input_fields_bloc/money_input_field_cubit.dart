import 'package:bloc/bloc.dart';

class MoneyInputFieldCubit extends Cubit<String> {
  MoneyInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
