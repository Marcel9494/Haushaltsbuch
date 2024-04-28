import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../blocs/button_blocs/categorie_type_toggle_buttons_bloc/categorie_type_toggle_buttons_cubit.dart';
import '../../components/deco/loading_indicator.dart';
import '/blocs/categorie_bloc/categorie_bloc.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/components/buttons/categorie_type_toggle_buttons.dart';
import '/components/buttons/save_button.dart';
import '/components/input_fields/text_input_field.dart';
import '/models/categorie/categorie_model.dart';
import '/models/categorie/categorie_repository.dart';
import '/utils/consts/global_consts.dart';

class CreateOrEditCategorieScreen extends StatefulWidget {
  const CreateOrEditCategorieScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditCategorieScreen> createState() => _CreateOrEditCategorieScreenState();

  static _CreateOrEditCategorieScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditCategorieScreenState>();
}

class _CreateOrEditCategorieScreenState extends State<CreateOrEditCategorieScreen> {
  late final CategorieBloc categorieBloc;
  late final CategorieTypeToggleButtonsCubit categorieTypeToggleButtonsCubit;
  late final TextInputFieldCubit categorieNameInputFieldCubit;
  //final TextEditingController _categorieNameController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  CategorieRepository categorieRepository = CategorieRepository();
  String _categorieNameErrorText = '';
  String _currentCategorieType = '';

  UniqueKey textInputFieldUniqueKey = UniqueKey();

  FocusNode categorieNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    categorieBloc = BlocProvider.of<CategorieBloc>(context);
    categorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    categorieTypeToggleButtonsCubit = BlocProvider.of<CategorieTypeToggleButtonsCubit>(context);
    //_categorieNameController.text = widget.categorieName;
    //_currentCategorieType = widget.categorieType;
  }

  /*void _createOrUpdateCategorie() async {
    final Categorie categorie = Categorie();
    categorie.name = _categorieNameController.text.trim();
    categorie.type = _currentCategorieType;
    // TODO bei Update Kategorie subcategorieNames nicht auf [] zurücksetzen, sondern beibehalten
    categorie.subcategorieNames = [];
    bool validCategorieName = await _validCategorieName(categorie);
    if (validCategorieName == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.categorieName == '') {
      categorieRepository.create(categorie);
    } else {
      categorieRepository.update(categorie, widget.categorieName);
    }
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, categoriesRoute);
      }
    });
  }*/

  Future<bool> _validCategorieName(Categorie categorie) async {
    if (categorie.name.isEmpty) {
      setState(() {
        _categorieNameErrorText = 'Bitte geben Sie einen Kategorienamen ein.';
      });
      return false;
    }
    /*if (widget.categorieName == '') {
      bool categorieNameExisting = await categorieRepository.existsCategorieName(categorie);
      if (categorieNameExisting) {
        setState(() {
          _categorieNameErrorText = 'Kategoriename ist bereits vorhanden.';
        });
        return false;
      }
    }*/
    _categorieNameErrorText = '';
    return true;
  }

  void _setSaveButtonAnimation(bool successful) {
    successful ? _saveButtonController.success() : _saveButtonController.error();
    if (successful == false) {
      Timer(const Duration(milliseconds: transitionInMs), () {
        _saveButtonController.reset();
      });
    }
  }

  set currentCategorieType(String categorieType) => setState(() => _currentCategorieType = categorieType);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CategorieBloc, CategorieState>(
        builder: (context, categorieState) {
          if (categorieState is CategorieLoadingState) {
            return const LoadingIndicator();
          } else if (categorieState is CategorieLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: categorieState.categorieIndex == -1 ? const Text('Kategorie erstellen') : const Text('Kategorie bearbeiten'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<CategorieTypeToggleButtonsCubit, CategorieTypeToggleButtonsModel>(
                        builder: (context, state) {
                          return CategorieTypeToggleButtons(cubit: categorieTypeToggleButtonsCubit);
                        },
                      ),
                      BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                        builder: (context, state) {
                          return TextInputField(
                              uniqueKey: textInputFieldUniqueKey,
                              focusNode: categorieNameFocusNode,
                              textCubit: categorieNameInputFieldCubit,
                              hintText: 'Kategoriename',
                              maxLength: 60);
                        },
                      ),
                      SaveButton(
                          saveFunction: () => categorieBloc.add(categorieState.categorieIndex == -1
                              ? CreateCategorieEvent(context, _saveButtonController)
                              : UpdateCategorieEvent(context, _saveButtonController, categorieState.categorieIndex)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Kategorieseite");
          }
        },
      ),
    );
  }
}
