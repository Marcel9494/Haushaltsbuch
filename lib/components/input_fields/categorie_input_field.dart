import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/deco/bottom_sheet_line.dart';

class CategorieInputField extends StatelessWidget {
  final TextEditingController textController;
  final String errorText;
  // TODO dynamische Kategorien Liste laden von Benutzer
  List<String> categories = ['Lebensmittel', 'Haushaltswaren', 'Restaurant', 'Mode/Kleidung', 'Transport', 'Möbel', 'Reisen', 'Wohnen', 'Garten', 'Sonstiges'];

  CategorieInputField({
    Key? key,
    required this.textController,
    required this.errorText,
  }) : super(key: key);

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
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20.0),
                  child: Text('Kategorie auswählen:', style: TextStyle(fontSize: 18.0)),
                ),
                Center(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (int i = 0; i < categories.length; i++)
                        OutlinedButton(
                          onPressed: () => {
                            textController.text = categories[i],
                            Navigator.pop(context),
                          },
                          child: Text(
                            categories[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
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
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
