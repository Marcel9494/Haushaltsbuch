import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CategorieInputField extends StatelessWidget {
  final TextEditingController textController;
  // TODO dynamische Kategorien Liste laden von Benutzer
  List<String> categories = ['Lebensmittel', 'Haushaltswaren', 'Restaurant', 'Mode/Kleidung', 'Transport'];

  CategorieInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  void _openBottomSheetWithCategorieList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              fontSize: 16.0,
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
      decoration: const InputDecoration(
        hintText: 'Kategorie',
        prefixIcon: Icon(
          Icons.donut_small_rounded,
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
