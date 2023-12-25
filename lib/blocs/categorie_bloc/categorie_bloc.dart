import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/utils/consts/route_consts.dart';

import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvents, CategorieState> {
  CategorieBloc() : super(CategorieInitial()) {
    on<InitializeCategorieEvent>((event, emit) {
      emit(CategorieLoadingState());
      TextInputFieldCubit categorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);

      categorieNameInputFieldCubit.resetValue();

      Navigator.pushNamed(event.context, createOrEditCategorieRoute);
      emit(CategorieLoadedState(event.context, -1));
    });
  }
}
