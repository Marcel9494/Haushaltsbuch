import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '/models/categorie.dart';
import '/models/enums/categorie_types.dart';
import '/models/screen_arguments/create_or_edit_categorie_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

import '../deco/loading_indicator.dart';

class CategorieTabView extends StatefulWidget {
  final CategorieType categorieType;

  const CategorieTabView({
    Key? key,
    required this.categorieType,
  }) : super(key: key);

  @override
  State<CategorieTabView> createState() => _CategorieTabViewState();
}

class _CategorieTabViewState extends State<CategorieTabView> {
  late List<Categorie> _categorieList = [];

  Future<List<Categorie>> _loadCategorieList() async {
    _categorieList = await Categorie.loadCategories(widget.categorieType);
    return _categorieList;
  }

  void _deleteCategorie(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kategorie ${_categorieList[index].name} löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Nein',
                style: TextStyle(
                  color: Colors.cyanAccent,
                ),
              ),
              onPressed: () => _noPressed(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.cyanAccent,
              ),
              onPressed: () => {
                _yesPressed(index),
                Flushbar(
                  title: 'Kategorie wurde gelöscht',
                  message: 'Kategorie ${_categorieList[index].name} wurde erfolgreich gelöscht.',
                  icon: const Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Colors.cyanAccent,
                  ),
                  duration: const Duration(seconds: 3),
                  leftBarIndicatorColor: Colors.cyanAccent,
                )..show(context),
              },
              child: const Text('Ja'),
            ),
          ],
        );
      },
    );
  }

  void _yesPressed(int index) {
    setState(() {
      _categorieList[index].deleteCategorie(_categorieList[index]);
    });
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: _loadCategorieList(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingIndicator();
                case ConnectionState.done:
                  if (_categorieList.isEmpty) {
                    return const Expanded(child: Center(child: Text('Noch keine Kategorien erstellt.')));
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _categorieList = await _loadCategorieList();
                          setState(() {});
                          return;
                        },
                        color: Colors.cyanAccent,
                        child: ListView.builder(
                          itemCount: _categorieList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_categorieList[index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => Navigator.pushNamed(context, createOrEditCategorieRoute,
                                        arguments: CreateOrEditCategorieScreenArguments(_categorieList[index].name, _categorieList[index].type!)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _deleteCategorie(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
    );
  }
}
