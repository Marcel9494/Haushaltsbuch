import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/buttons/save_button.dart';
import '/components/input_fields/text_input_field.dart';

import '/models/categorie.dart';
import '/models/enums/mode_types.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

class CreateOrEditSubcategorieScreen extends StatefulWidget {
  final Categorie categorie;
  final ModeType mode;

  const CreateOrEditSubcategorieScreen({
    Key? key,
    required this.categorie,
    required this.mode,
  }) : super(key: key);

  @override
  State<CreateOrEditSubcategorieScreen> createState() => _CreateOrEditSubcategorieScreenState();

  static _CreateOrEditSubcategorieScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditSubcategorieScreenState>();
}

class _CreateOrEditSubcategorieScreenState extends State<CreateOrEditSubcategorieScreen> {
  final TextEditingController _subcategorieNameController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  //final Categorie _categorie = Categorie();
  String _subcategorieNameErrorText = '';

  @override
  void initState() {
    super.initState();
    if (widget.mode == ModeType.editMode) {
      _subcategorieNameController.text = widget.categorie.subcategorieNames[0];
    }
  }

  void _createOrUpdateSubcategorie() async {
    //_categorie.name = widget.categorie.name;
    //_categorie.type = widget.categorie.type;
    bool validSubcategorieName = await _validSubcategorieName(_subcategorieNameController.text.trim());
    if (validSubcategorieName == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.mode == ModeType.creationMode) {
      widget.categorie.updateSubcategories(widget.categorie, _subcategorieNameController.text.trim());
    } else {
      // TODO _categorie.updateCategorie(_categorie, ''); // TODO '' ersetzen durch Variable
    }
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: transitionInMs), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, categoriesRoute);
      }
    });
  }

  // TODO Validierung in Categorie Model auslagern / implementieren
  Future<bool> _validSubcategorieName(String subcategorieName) async {
    if (subcategorieName.isEmpty) {
      setState(() {
        _subcategorieNameErrorText = 'Bitte geben Sie einen Unterkategorienamen ein.';
      });
      return false;
    }
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: widget.mode == ModeType.creationMode ? const Text('Unterkategorie erstellen') : const Text('Unterkategorie bearbeiten'),
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
                TextInputField(textEditingController: _subcategorieNameController, errorText: _subcategorieNameErrorText, hintText: 'Unterkategoriename', autofocus: true),
                SaveButton(saveFunction: _createOrUpdateSubcategorie, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
