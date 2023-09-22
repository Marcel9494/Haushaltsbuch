import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/buttons/categorie_type_toggle_buttons.dart';
import '/components/buttons/save_button.dart';
import '/components/input_fields/text_input_field.dart';

import '/models/categorie.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

class CreateOrEditCategorieScreen extends StatefulWidget {
  final String categorieName;
  final String categorieType;

  const CreateOrEditCategorieScreen({
    Key? key,
    required this.categorieName,
    required this.categorieType,
  }) : super(key: key);

  @override
  State<CreateOrEditCategorieScreen> createState() => _CreateOrEditCategorieScreenState();

  static _CreateOrEditCategorieScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditCategorieScreenState>();
}

class _CreateOrEditCategorieScreenState extends State<CreateOrEditCategorieScreen> {
  final TextEditingController _categorieNameController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  final Categorie _categorie = Categorie();
  String _categorieNameErrorText = '';
  String _currentCategorieType = '';

  @override
  void initState() {
    super.initState();
    _categorieNameController.text = widget.categorieName;
    _currentCategorieType = widget.categorieType;
  }

  void _createOrUpdateCategorie() async {
    _categorie.name = _categorieNameController.text.trim();
    _categorie.type = _currentCategorieType;
    bool validCategorieName = await _validCategorieName(_categorie);
    if (validCategorieName == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.categorieName == '') {
      _categorie.createCategorie(_categorie);
    } else {
      _categorie.updateCategorie(_categorie, widget.categorieName);
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
  }

  Future<bool> _validCategorieName(Categorie categorie) async {
    if (categorie.name.isEmpty) {
      setState(() {
        _categorieNameErrorText = 'Bitte geben Sie einen Kategorienamen ein.';
      });
      return false;
    }
    if (widget.categorieName == '') {
      bool categorieNameExisting = await _categorie.existsCategorieName(categorie);
      if (categorieNameExisting) {
        setState(() {
          _categorieNameErrorText = 'Kategoriename ist bereits vorhanden.';
        });
        return false;
      }
    }
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: widget.categorieName == '' ? const Text('Hauptkategorie erstellen') : const Text('Hauptkategorie bearbeiten'),
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
                CategorieTypeToggleButtons(
                    currentCategorieType: _currentCategorieType, categorieTypeStringCallback: (categorie) => setState(() => _currentCategorieType = categorie)),
                TextInputField(textEditingController: _categorieNameController, errorText: _categorieNameErrorText, hintText: 'Kategoriename', autofocus: true),
                SaveButton(saveFunction: _createOrUpdateCategorie, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
