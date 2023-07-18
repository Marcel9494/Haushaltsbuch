import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

import '/models/categorie.dart';

class CategorieInputField extends StatefulWidget {
  final TextEditingController textController;
  final String errorText;
  final String transactionType;
  final String title;
  final bool autofocus;

  const CategorieInputField({
    Key? key,
    required this.textController,
    required this.errorText,
    required this.transactionType,
    this.title = 'Kategorie auswählen:',
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<CategorieInputField> createState() => _CategorieInputFieldState();
}

class _CategorieInputFieldState extends State<CategorieInputField> {
  List<String> categorieNames = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autofocus) {
      // Future.delayed Grund siehe: https://stackoverflow.com/q/58027568/15943768
      Future.delayed(Duration.zero, () {
        _openBottomSheetWithCategorieList(context);
      });
    }
  }

  void _openBottomSheetWithCategorieList(BuildContext context) {
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
                  future: _loadCategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (categorieNames.isEmpty) {
                          return const Text('Erstelle zuerst eine Kategorie.');
                        } else {
                          return Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < categorieNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.textController.text = categorieNames[i],
                                      Navigator.pop(context),
                                    },
                                    child: Text(
                                      categorieNames[i],
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

  Future<List<String>> _loadCategorieNameList() async {
    categorieNames = await Categorie.loadCategorieNames(widget.transactionType);
    return categorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      autofocus: widget.autofocus,
      onTap: () => _openBottomSheetWithCategorieList(context),
      decoration: InputDecoration(
        hintText: 'Kategorie',
        prefixIcon: const Icon(
          Icons.donut_small_rounded,
          color: Colors.grey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
        errorText: widget.errorText.isEmpty ? null : widget.errorText,
      ),
    );
  }
}
