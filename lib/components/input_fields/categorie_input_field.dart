import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../blocs/input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';

import '/models/enums/categorie_types.dart';
import '/models/categorie/categorie_repository.dart';

import '/components/deco/bottom_sheet_line.dart';

import '../deco/bottom_sheet_header.dart';
import '../deco/bottom_sheet_empty_list.dart';

class CategorieInputField extends StatefulWidget {
  final dynamic cubit;
  final FocusNode focusNode;
  final CategorieType categorieType;
  final String title;
  final bool autofocus;

  const CategorieInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
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
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(
              children: [
                const BottomSheetLine(),
                BottomSheetHeader(title: widget.title),
                FutureBuilder(
                  future: _loadCategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        if (_categorieNames.isEmpty) {
                          return const BottomSheetEmptyList(text: 'Erstelle zuerst eine Kategorie.');
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
                                for (int i = 0; i < _categorieNames.length; i++)
                                  OutlinedButton(
                                    onPressed: () => {
                                      widget.cubit.updateValue(_categorieNames[i]),
                                      BlocProvider.of<SubcategorieInputFieldCubit>(context).resetValue(),
                                      Navigator.pop(context),
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: widget.cubit.state.categorie == _categorieNames[i] ? 1.5 : 1.0,
                                          color: widget.cubit.state.categorie == _categorieNames[i] ? Colors.cyanAccent : Colors.grey.shade800),
                                    ),
                                    child: Text(
                                      _categorieNames[i],
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
                                    side: BorderSide(
                                        width: widget.cubit.state.categorie == '' ? 1.5 : 1.0,
                                        color: widget.cubit.state.categorie == '' ? Colors.cyanAccent : Colors.grey.shade800),
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

  Future<List<String>> _loadCategorieNameList() async {
    CategorieRepository categorieRepository = CategorieRepository();
    _categorieNames = await categorieRepository.loadCategorieNameList(widget.categorieType);
    return _categorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      focusNode: widget.focusNode,
      initialValue: widget.cubit.state.categorie,
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
        errorText: widget.cubit.state.errorText.isEmpty ? null : widget.cubit.state.errorText,
      ),
    );
  }
}
