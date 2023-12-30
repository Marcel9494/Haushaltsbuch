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
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.cyanAccent,
          labelPadding: EdgeInsets.zero,
          tabs: <Widget>[
            Tab(text: CategorieType.outcome.pluralName),
            Tab(text: CategorieType.income.pluralName),
            Tab(text: CategorieType.investment.pluralName),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[
            CategorieTabView(categorieType: CategorieType.outcome),
            CategorieTabView(categorieType: CategorieType.income),
            CategorieTabView(categorieType: CategorieType.investment),
          ],
        ),
      ),
    );
  }
}
