import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../models/categorie/categorie_model.dart';
import '../../models/categorie/categorie_repository.dart';
import '../../utils/consts/global_consts.dart';
import '../button_blocs/categorie_type_toggle_buttons_bloc/categorie_type_toggle_buttons_cubit.dart';
import '/utils/consts/route_consts.dart';

import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvents, CategorieState> {
  CategorieRepository categorieRepository = CategorieRepository();

  CategorieBloc() : super(CategorieInitial()) {
    on<InitializeCategorieEvent>((event, emit) {
      emit(CategorieLoadingState());
      CategorieTypeToggleButtonsCubit categorieTypeToggleButtonsCubit = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);

      categorieTypeToggleButtonsCubit.initCategorieType();
      categorieNameInputFieldCubit.resetValue();

      Navigator.pushNamed(event.context, createOrEditCategorieRoute);
      emit(CategorieLoadedState(event.context, -1));
    });

    on<CreateCategorieEvent>((event, emit) async {
      CategorieTypeToggleButtonsCubit categorieTypeToggleButtonsCubit = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);

      if (categorieNameInputFieldCubit.validateValue(categorieNameInputFieldCubit.state.text) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        Categorie newCategorie = Categorie()
          ..name = categorieNameInputFieldCubit.state.text
          ..subcategorieNames = []
          ..type = categorieTypeToggleButtonsCubit.state.categorieType;
        categorieRepository.create(newCategorie);
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, categoriesRoute);
    });
  }
}
