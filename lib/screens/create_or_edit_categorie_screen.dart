import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/buttons/save_button.dart';
import '/components/input_fields/text_input_field.dart';

import '/models/categorie.dart';

import '/utils/consts/route_consts.dart';

class CreateOrEditCategorieScreen extends StatefulWidget {
  final String categorieName;

  const CreateOrEditCategorieScreen({
    Key? key,
    required this.categorieName,
  }) : super(key: key);

  @override
  State<CreateOrEditCategorieScreen> createState() => _CreateOrEditCategorieScreenState();
}

class _CreateOrEditCategorieScreenState extends State<CreateOrEditCategorieScreen> {
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  final Categorie _categorie = Categorie();
  String _categorieName = '';
  String _categorieNameErrorText = '';

  @override
  void initState() {
    super.initState();
    _categorieName = widget.categorieName;
  }

  void _createOrUpdateCategorie() async {
    _categorie.name = _categorieName.trim();
    bool validCategorieName = await _validCategorieName(_categorieName);
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

  Future<bool> _validCategorieName(String categorieNameInput) async {
    if (_categorieName.isEmpty) {
      setState(() {
        _categorieNameErrorText = 'Bitte geben Sie einen Kategorienamen ein.';
      });
      return false;
    }
    if (widget.categorieName == '') {
      bool categorieNameExisting = await _categorie.existsCategorieName(_categorieName);
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
          title: widget.categorieName == '' ? const Text('Kategorie erstellen') : const Text('Kategorie bearbeiten'),
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
                SaveButton(saveFunction: _createOrUpdateCategorie, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
