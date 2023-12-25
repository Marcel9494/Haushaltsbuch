import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/categorie_bloc/categorie_bloc.dart';
import '/components/tab_bar/categories_tab_bar.dart';

import '/utils/consts/route_consts.dart';

import '/models/enums/categorie_types.dart';
import '/models/screen_arguments/create_or_edit_categorie_screen_arguments.dart';

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
