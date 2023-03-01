import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/utils/consts/route_consts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/buttons/save_button.dart';
import '/components/input_fields/text_input_field.dart';

import '/models/categorie.dart';

class CreateOrEditCategorieScreen extends StatefulWidget {
  const CreateOrEditCategorieScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditCategorieScreen> createState() => _CreateOrEditCategorieScreenState();
}

class _CreateOrEditCategorieScreenState extends State<CreateOrEditCategorieScreen> {
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  String _categorieName = '';
  String _categorieNameErrorText = '';

  void _createCategorie() {
    if (_validCategorieName(_categorieName) == false) {
      _setSaveButtonAnimation(false);
    } else {
      Categorie categorie = Categorie();
      categorie.name = _categorieName;
      categorie.createCategorie(categorie);
      _setSaveButtonAnimation(true);
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, categoriesRoute);
        }
      });
    }
  }

  bool _validCategorieName(String categorieNameInput) {
    if (_categorieName.isEmpty) {
      setState(() {
        _categorieNameErrorText = 'Bitte geben Sie einen Kategorienamen ein.';
      });
      return false;
    }
    _categorieNameErrorText = '';
    return true;
  }

  void _setCategorieNameState(String categorieName) {
    setState(() {
      _categorieName = categorieName;
    });
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
      child: Scaffold(
        backgroundColor: const Color(0x00ffffff),
        appBar: AppBar(
          title: const Text('Kategorie erstellen'),
          backgroundColor: const Color(0x00ffffff),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0x1fffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInputField(input: _categorieName, inputCallback: _setCategorieNameState, errorText: _categorieNameErrorText, hintText: 'Kategoriename', autofocus: true),
                SaveButton(saveFunction: _createCategorie, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
