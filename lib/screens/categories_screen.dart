import 'package:flutter/material.dart';

import '/components/deco/loading_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorien'),
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
                    return RefreshIndicator(
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
                          );
                        },
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
