import 'package:flutter/material.dart';

import '/models/categorie.dart';
import '/models/enums/categorie_types.dart';

import '../cards/categorie_card.dart';

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
                            return CategorieCard(categorie: _categorieList[index], categorieIndex: index);
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
