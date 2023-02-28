import 'package:flutter/material.dart';
import 'package:haushaltsbuch/components/buttons/save_button.dart';
import 'package:haushaltsbuch/components/input_fields/text_input_field.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
    // TODO hier weitermachen und Kategorien erstellen implementieren und anschließend zu Kategorie Seite wechseln und Kategorien in Liste anzeigen
  }

  void _setCategorieNameState(String categorieName) {
    setState(() {
      _categorieName = categorieName;
    });
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
                TextInputField(input: _categorieName, inputCallback: _setCategorieNameState, errorText: _categorieNameErrorText, hintText: 'Kategoriename'),
                SaveButton(saveFunction: _createCategorie, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
