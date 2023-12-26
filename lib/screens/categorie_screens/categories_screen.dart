import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/categorie_bloc/categorie_bloc.dart';

import '/components/tab_bar/categories_tab_bar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorien verwalten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              BlocProvider.of<CategorieBloc>(context).add(InitializeCategorieEvent(context));
            },
          ),
        ],
      ),
      body: const CategoriesTabBar(),
    );
  }
}
