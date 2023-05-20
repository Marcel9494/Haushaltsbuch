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
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_downward_rounded, size: 14.0),
                  Text(CategorieType.outcome.pluralName),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_upward_rounded, size: 14.0),
                  Text(CategorieType.income.pluralName),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.moving_rounded, size: 14.0),
                  Text(CategorieType.investment.pluralName),
                ],
              ),
            ),
            //Tab(text: CategorieType.outcome.pluralName, icon: const Icon(Icons.arrow_downward_rounded, size: 12.0)),
            //Tab(text: CategorieType.income.pluralName),
            //Tab(text: CategorieType.investment.pluralName),
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
