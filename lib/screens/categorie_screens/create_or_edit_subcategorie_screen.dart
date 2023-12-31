import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/categorie_bloc/categorie_bloc.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';

import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';
import '/components/input_fields/text_input_field.dart';

import '/models/categorie/categorie_repository.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

class CreateOrEditSubcategorieScreen extends StatefulWidget {
  const CreateOrEditSubcategorieScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditSubcategorieScreen> createState() => _CreateOrEditSubcategorieScreenState();

  static _CreateOrEditSubcategorieScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditSubcategorieScreenState>();
}

class _CreateOrEditSubcategorieScreenState extends State<CreateOrEditSubcategorieScreen> {
  late final CategorieBloc categorieBloc;
  late final TextInputFieldCubit subcategorieNameInputFieldCubit;
  //final TextEditingController _subcategorieNameController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  //late final TextInputFieldCubit textInputFieldCubit;
  String _subcategorieNameErrorText = '';
  String _oldSubcategorie = '';

  UniqueKey subcategorieNameUniqueKey = UniqueKey();

  FocusNode subcategorieNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    categorieBloc = BlocProvider.of<CategorieBloc>(context);
    subcategorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    //textInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    /*if (widget.mode == ModeType.editMode) {
      _oldSubcategorie = widget.categorie.subcategorieNames[widget.subcategorieIndex];
      _subcategorieNameController.text = widget.categorie.subcategorieNames[widget.subcategorieIndex];
    }*/
  }

  /*void _createOrUpdateSubcategorie() async {
    bool validSubcategorieName = await _validSubcategorieName(_subcategorieNameController.text.trim());
    if (validSubcategorieName == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    CategorieRepository categorieRepository = CategorieRepository();
    /*if (widget.mode == ModeType.creationMode) {
      // TODO categorieRepository.createSubcategorie(widget.categorie.name, textInputFieldCubit.state.trim());
    } else {
      // TODO categorieRepository.updateSubcategorie(widget.categorie.name, _oldSubcategorie, textInputFieldCubit.state.trim());
    }*/
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: transitionInMs), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, categoriesRoute);
      }
    });
  }*/

  // TODO Validierung in Categorie Model auslagern / implementieren
  Future<bool> _validSubcategorieName(String subcategorieName) async {
    // TODO implementieren
    /*if (textInputFieldCubit.state.isEmpty) {
      setState(() {
        _subcategorieNameErrorText = 'Bitte geben Sie einen Unterkategorienamen ein.';
      });
      return false;
    }*/
    // TODO muss noch implementiert werden
    /*if (widget.mode == ModeType.creationMode) {
      bool categorieNameExisting = await categorie.existsSubcategorieName(categorie);
      if (categorieNameExisting) {
        setState(() {
          _subcategorieNameErrorText = 'Kategoriename ist bereits vorhanden.';
        });
        return false;
      }
    }*/
    _subcategorieNameErrorText = '';
    return true;
  }

  void _setSaveButtonAnimation(bool successful) {
    successful ? _saveButtonController.success() : _saveButtonController.error();
    if (successful == false) {
      Timer(const Duration(seconds: 1), () {
        _saveButtonController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CategorieBloc, CategorieState>(
        builder: (context, subcategorieState) {
          if (subcategorieState is SubcategorieLoadingState) {
            return const LoadingIndicator();
          } else if (subcategorieState is SubcategorieLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: subcategorieState.categorieIndex == -1 ? const Text('Unterkategorie erstellen') : const Text('Unterkategorie bearbeiten'),
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
                      BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                        builder: (context, state) {
                          return TextInputField(
                              fieldKey: subcategorieNameUniqueKey,
                              focusNode: subcategorieNameFocusNode,
                              textCubit: subcategorieNameInputFieldCubit,
                              hintText: 'Unterkategoriename',
                              maxLength: 60);
                        },
                      ),
                      SaveButton(
                          saveFunction: () => categorieBloc.add(subcategorieState.categorieIndex == -1
                              ? CreateSubcategorieEvent(context, _saveButtonController)
                              : UpdateSubcategorieEvent(context, _saveButtonController, subcategorieState.categorie)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Unterkategorieseite");
          }
        },
      ),
    );
  }
}
