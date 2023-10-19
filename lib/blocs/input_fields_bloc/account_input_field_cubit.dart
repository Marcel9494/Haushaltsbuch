import 'package:bloc/bloc.dart';

class AccountInputFieldCubit extends Cubit<String> {
  AccountInputFieldCubit() : super("");
  void updateValue(String newValue) => emit(newValue);
  void resetValue() => emit("");
}
