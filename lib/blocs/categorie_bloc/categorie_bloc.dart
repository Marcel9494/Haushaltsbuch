import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haushaltsbuch/models/booking/booking_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '../button_blocs/categorie_type_toggle_buttons_bloc/categorie_type_toggle_buttons_cubit.dart';

import '/models/budget/budget_repository.dart';
import '/models/categorie/categorie_model.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/global_consts.dart';
import '/utils/consts/route_consts.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvents, CategorieState> {
  CategorieRepository categorieRepository = CategorieRepository();
  BookingRepository bookingRepository = BookingRepository();
  BudgetRepository budgetRepository = BudgetRepository();
  String savedCategorieName = "";
  String savedSubcategorieName = "";
  List<String> savedSubcategories = [];

  CategorieBloc() : super(CategorieInitial()) {
    on<InitializeCategorieEvent>((event, emit) {
      emit(CategorieLoadingState());
      CategorieTypeToggleButtonsCubit categorieType = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      savedCategorieName = categorieName.state.text;

      categorieType.initCategorieType();
      categorieName.resetValue();

      Navigator.pushNamed(event.context, createOrEditCategorieRoute);
      emit(CategorieLoadedState(event.context, -1));
    });

    on<CreateCategorieEvent>((event, emit) async {
      CategorieTypeToggleButtonsCubit categorieType = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      if (categorieName.validateValue(categorieName.state.text) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else if (await categorieRepository.existsCategorieName(categorieName.state.text, categorieType.state.categorieType)) {
        categorieName.emit(TextInputFieldModel(categorieName.state.text, "Kategorie " + categorieName.state.text + " ist bereits vorhanden."));
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        GlobalStateRepository globalStateRepository = GlobalStateRepository();
        Categorie newCategorie = Categorie()
          ..index = await globalStateRepository.getCategorieIndex()
          ..name = categorieName.state.text
          ..subcategorieNames = []
          ..type = categorieType.state.categorieType;
        categorieRepository.create(newCategorie);
        globalStateRepository.increaseCategorieIndex();
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, categoriesRoute);
    });

    on<LoadCategorieEvent>((event, emit) async {
      emit(CategorieLoadingState());
      CategorieTypeToggleButtonsCubit categorieType = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      Categorie loadedCategorie = await categorieRepository.load(event.categorieIndex);

      savedCategorieName = loadedCategorie.name;
      savedSubcategories = loadedCategorie.subcategorieNames;

      categorieType.setCategorieType(loadedCategorie.type!);
      categorieName.updateValue(loadedCategorie.name);

      Navigator.pushNamed(event.context, createOrEditCategorieRoute);
      emit(CategorieLoadedState(event.context, event.categorieIndex));
    });

    on<UpdateCategorieEvent>((event, emit) async {
      CategorieTypeToggleButtonsCubit categorieType = BlocProvider.of<CategorieTypeToggleButtonsCubit>(event.context);
      TextInputFieldCubit categorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      if (categorieName.validateValue(categorieName.state.text) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else if (await categorieRepository.existsCategorieName(categorieName.state.text, categorieType.state.categorieType)) {
        categorieName.emit(TextInputFieldModel(
            categorieName.state.text, "Kategorie " + categorieName.state.text + " ist bereits als " + categorieType.state.categorieType + " Kategorie vorhanden."));
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        Categorie updatedCategorie = Categorie()
          ..index = event.categorieIndex
          ..name = categorieName.state.text
          ..subcategorieNames = savedSubcategories
          ..type = categorieType.state.categorieType;
        categorieRepository.update(updatedCategorie, savedCategorieName);
        bookingRepository.updateCategorieName(savedCategorieName, updatedCategorie.name);
        budgetRepository.updateBudgetCategorieName(savedCategorieName, updatedCategorie.name);
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      // Damit die Kategorien in der Buchungsliste aktualisiert werden, wird der Bildschirm Stack abgebaut und neu aufgebaut.
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
      Navigator.pushNamed(event.context, categoriesRoute);
    });

    on<DeleteCategorieEvent>((event, emit) async {
      categorieRepository.delete(event.deleteCategorie);
      budgetRepository.deleteAllBudgetsFromCategorie(event.deleteCategorie.name);
      // Damit die Kategorien in der Budgetliste aktualisiert werden, wird der Bildschirm Stack abgebaut und neu aufgebaut.
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
      Navigator.pushNamed(event.context, categoriesRoute);
    });

    on<InitializeSubcategorieEvent>((event, emit) {
      emit(SubcategorieLoadingState());
      TextInputFieldCubit subcategorieName = BlocProvider.of<TextInputFieldCubit>(event.context);
      savedCategorieName = event.categorie.name;
      savedSubcategories = event.categorie.subcategorieNames;

      subcategorieName.resetValue();

      Navigator.pushNamed(event.context, createOrEditSubcategorieRoute);
      emit(SubcategorieLoadedState(event.context, -1, event.categorie));
    });

    on<CreateSubcategorieEvent>((event, emit) async {
      TextInputFieldCubit subcategorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      if (subcategorieName.validateValue(subcategorieName.state.text) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else if (savedSubcategories.contains(subcategorieName.state.text)) {
        subcategorieName.emit(TextInputFieldModel(subcategorieName.state.text, "Kategorie " + subcategorieName.state.text + " ist bereits vorhanden."));
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        categorieRepository.createSubcategorie(savedCategorieName, subcategorieName.state.text);
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, categoriesRoute);
    });

    on<LoadSubcategorieEvent>((event, emit) async {
      emit(SubcategorieLoadingState());
      TextInputFieldCubit subcategorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      savedCategorieName = event.subcategorieName;
      savedSubcategories = event.categorie.subcategorieNames;
      savedSubcategorieName = event.subcategorieName;

      subcategorieName.updateValue(event.subcategorieName);

      Navigator.pushNamed(event.context, createOrEditSubcategorieRoute);
      emit(SubcategorieLoadedState(event.context, event.categorie.index, event.categorie));
    });

    on<UpdateSubcategorieEvent>((event, emit) async {
      TextInputFieldCubit subcategorieName = BlocProvider.of<TextInputFieldCubit>(event.context);

      if (subcategorieName.validateValue(subcategorieName.state.text) == false) {
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else if (savedSubcategories.contains(subcategorieName.state.text)) {
        subcategorieName.emit(TextInputFieldModel(subcategorieName.state.text, "Kategorie " + subcategorieName.state.text + " ist bereits vorhanden."));
        event.saveButtonController.error();
        Timer(const Duration(milliseconds: transitionInMs), () {
          event.saveButtonController.reset();
        });
        return;
      } else {
        categorieRepository.updateSubcategorie(event.categorie.name, savedSubcategorieName, subcategorieName.state.text);
        bookingRepository.updateSubcategorieName(savedSubcategorieName, subcategorieName.state.text);
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      // Damit die Unterkategorien in der Buchungsliste aktualisiert werden, wird der Bildschirm Stack abgebaut und neu aufgebaut.
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      Navigator.pushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
      Navigator.pushNamed(event.context, categoriesRoute);
    });

    on<DeleteSubcategorieEvent>((event, emit) async {
      categorieRepository.deleteSubcategorie(event.mainCategorie, event.deleteSubcategorie);
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, categoriesRoute);
    });
  }
}
