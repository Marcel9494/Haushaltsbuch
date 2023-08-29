import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/models/categorie.dart';

import '../deco/bottom_sheet_line.dart';

class SubcategorieInputField extends StatefulWidget {
  final TextEditingController textController;
  final String categorieName;
  final String title;

  const SubcategorieInputField({
    Key? key,
    required this.textController,
    required this.categorieName,
    this.title = 'Unterkategorie auswählen:',
  }) : super(key: key);

  @override
  State<SubcategorieInputField> createState() => _SubcategorieInputFieldState();
}

class _SubcategorieInputFieldState extends State<SubcategorieInputField> {
  List<String> _subcategorieNames = [];

  void _openBottomSheetWithSubcategorieList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 400,
            child: ListView(
              children: [
                const BottomSheetLine(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 20.0),
                  child: Text(widget.title, style: const TextStyle(fontSize: 18.0)),
                ),
                FutureBuilder(
                  future: _loadSubcategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (_subcategorieNames.isEmpty) {
                          return const Text('Erstelle zuerst eine Unterkategorie.');
                        } else {
                          return Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisCount: 4,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < _subcategorieNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.textController.text = _subcategorieNames[i],
                                      Navigator.pop(context),
                                    },
                                    child: Text(
                                      _subcategorieNames[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _loadSubcategorieNameList() async {
    _subcategorieNames = await Categorie.loadSubcategorieNames(widget.categorieName);
    return _subcategorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      onTap: () => _openBottomSheetWithSubcategorieList(context),
      decoration: const InputDecoration(
        hintText: 'Unterkategorie',
        prefixIcon: Icon(
          Icons.donut_large_rounded,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
