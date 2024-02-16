import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';

import '/models/categorie/categorie_repository.dart';

import '../deco/bottom_sheet_line.dart';
import '../deco/bottom_sheet_header.dart';
import '../deco/bottom_sheet_empty_list.dart';

class SubcategorieInputField extends StatefulWidget {
  final dynamic cubit;
  final FocusNode focusNode;
  final String title;

  const SubcategorieInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
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
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(
              children: [
                const BottomSheetLine(),
                BottomSheetHeader(title: widget.title),
                FutureBuilder(
                  future: _loadSubcategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (_subcategorieNames.isEmpty) {
                          return const BottomSheetEmptyList(text: 'Erstelle zuerst eine Unterkategorie.');
                        } else {
                          return Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                              crossAxisCount: 4,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              shrinkWrap: true,
                              children: <Widget>[
                                for (int i = 0; i < _subcategorieNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.cubit.updateValue(_subcategorieNames[i]),
                                      Navigator.pop(context),
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: widget.cubit.state == _subcategorieNames[i] ? 1.5 : 1.0,
                                          color: widget.cubit.state == _subcategorieNames[i] ? Colors.cyanAccent : Colors.grey.shade800),
                                    ),
                                    child: Text(
                                      _subcategorieNames[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                OutlinedButton(
                                  onPressed: () => {
                                    widget.cubit.updateValue(''),
                                    Navigator.pop(context),
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(width: widget.cubit.state == '' ? 1.5 : 1.0, color: widget.cubit.state == '' ? Colors.cyanAccent : Colors.grey.shade800),
                                  ),
                                  child: const Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
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
    CategorieRepository categorieRepository = CategorieRepository();
    _subcategorieNames = await categorieRepository.loadSubcategorieNameList(BlocProvider.of<CategorieInputFieldCubit>(context).state.categorie);
    return _subcategorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: widget.focusNode,
      initialValue: widget.cubit.state,
      textAlignVertical: TextAlignVertical.center,
      showCursor: false,
      readOnly: true,
      onTap: () => _openBottomSheetWithSubcategorieList(context),
      decoration: const InputDecoration(
        hintText: 'Unterkategorie (optional)',
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
