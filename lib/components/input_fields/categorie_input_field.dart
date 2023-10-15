import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../blocs/input_fields_bloc/subcategorie_input_field_cubit.dart';
import '/models/enums/categorie_types.dart';
import '/models/categorie/categorie_repository.dart';

import '/components/deco/bottom_sheet_line.dart';

class CategorieInputField extends StatefulWidget {
  final dynamic cubit;
  final String errorText;
  final CategorieType categorieType;
  final String title;
  final bool autofocus;

  const CategorieInputField({
    Key? key,
    required this.cubit,
    required this.errorText,
    required this.categorieType,
    this.title = 'Kategorie auswählen:',
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<CategorieInputField> createState() => _CategorieInputFieldState();
}

class _CategorieInputFieldState extends State<CategorieInputField> {
  List<String> _categorieNames = [];

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
                        if (_categorieNames.isEmpty) {
                          return const Text('Erstelle zuerst eine Kategorie.');
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
                                for (int i = 0; i < _categorieNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.cubit.updateValue(_categorieNames[i]),
                                      BlocProvider.of<SubcategorieInputFieldCubit>(context).resetValue(),
                                      Navigator.pop(context),
                                    },
                                    child: Text(
                                      _categorieNames[i],
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
    CategorieRepository categorieRepository = CategorieRepository();
    _categorieNames = await categorieRepository.loadCategorieNameList(widget.categorieType);
    return _categorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      initialValue: widget.cubit.state,
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
