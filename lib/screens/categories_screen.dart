import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/components/deco/loading_indicator.dart';

import '/utils/consts/route_consts.dart';

import '/models/categorie.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Categorie> _categorieList = [];

  Future<List<Categorie>> _loadCategorieList() async {
    _categorieList = await Categorie.loadCategories();
    return _categorieList;
  }

  void _deleteCategorie(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kategorie löschen?'),
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
                primary: Colors.cyanAccent,
                onPrimary: Colors.black87,
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
      appBar: AppBar(
        title: const Text('Kategorien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, createOrEditCategorieRoute);
            },
          ),
        ],
      ),
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
                    return const Center(child: Text('Noch keine Kategorien erstellt.'));
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
                              trailing: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _deleteCategorie(index),
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
