import 'package:flutter/material.dart';

import '/models/enums/categorie_types.dart';

import '../tab_views/categorie_tab_view.dart';

class CategoriesTabBar extends StatefulWidget {
  const CategoriesTabBar({Key? key}) : super(key: key);

  @override
  State<CategoriesTabBar> createState() => _CategoriesTabBarState();
}

class _CategoriesTabBarState extends State<CategoriesTabBar> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.cyanAccent,
          tabs: <Widget>[
            Tab(text: 'Ausgaben'),
            Tab(text: 'Einnahmen'),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            CategorieTabView(categorieType: CategorieType.outcome),
            CategorieTabView(categorieType: CategorieType.income),
          ],
        ),
      ),
    );
  }
}
