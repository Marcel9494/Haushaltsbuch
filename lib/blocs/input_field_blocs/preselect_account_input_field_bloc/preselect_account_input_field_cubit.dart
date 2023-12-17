import 'package:bloc/bloc.dart';

part 'preselect_account_input_field_model.dart';

class PreselectAccountInputFieldCubit extends Cubit<PreselectAccountInputFieldModel> {
  PreselectAccountInputFieldCubit() : super(PreselectAccountInputFieldModel(""));
  void updateValue(String newValue) => emit(PreselectAccountInputFieldModel(newValue));
  void resetValue() => emit(PreselectAccountInputFieldModel(""));
}
