import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/categorie_bloc/categorie_bloc.dart';

import '/models/categorie/categorie_model.dart';

class CategorieCard extends StatefulWidget {
  final Categorie categorie;

  const CategorieCard({
    Key? key,
    required this.categorie,
  }) : super(key: key);

  @override
  State<CategorieCard> createState() => _CategorieCardState();
}

class _CategorieCardState extends State<CategorieCard> {
  String allSubcategorieNames = "";

  void _showDeleteCategorieDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kategorie ${widget.categorie.name} löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Nein',
                style: TextStyle(
                  color: Colors.cyanAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.cyanAccent,
              ),
              onPressed: () => BlocProvider.of<CategorieBloc>(context).add(DeleteCategorieEvent(context, widget.categorie)),
              child: const Text('Ja'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSubcategorieDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unterkategorie ${widget.categorie.subcategorieNames[index]} löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Nein',
                style: TextStyle(
                  color: Colors.cyanAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.cyanAccent,
              ),
              onPressed: () => BlocProvider.of<CategorieBloc>(context).add(DeleteSubcategorieEvent(context, widget.categorie, widget.categorie.subcategorieNames[index])),
              child: const Text('Ja'),
            ),
          ],
        );
      },
    );
  }

  String _getSubcategorieNames(List<String> subcategorieNames) {
    for (int i = 0; i < subcategorieNames.length; i++) {
      allSubcategorieNames += i == 0 ? widget.categorie.subcategorieNames[i] : " · " + widget.categorie.subcategorieNames[i];
    }
    return allSubcategorieNames;
  }

  // TODO hier weitermachen und Karten UI verbessern siehe als Beispiel MoneyManager
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.only(left: 8.0),
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0.0,
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          textColor: Colors.white,
          iconColor: Colors.white70,
          tilePadding: const EdgeInsets.only(left: 8.0),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.remove_circle_outline_rounded),
                onPressed: () => _showDeleteCategorieDialog(),
              ),
            ],
          ),
          title: Text(
            widget.categorie.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16.0),
          ),
          subtitle: widget.categorie.subcategorieNames.isEmpty
              ? const Text('-', style: TextStyle(fontSize: 12.0, color: Colors.grey))
              : Text(
                  _getSubcategorieNames(widget.categorie.subcategorieNames),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit),
                onPressed: () => BlocProvider.of<CategorieBloc>(context).add(LoadCategorieEvent(context, widget.categorie.index)),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 4.0, right: 12.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.add_rounded),
                onPressed: () => BlocProvider.of<CategorieBloc>(context).add(InitializeSubcategorieEvent(context, widget.categorie)),
              ),
            ],
          ),
          children: <Widget>[
            SizedBox(
              height: widget.categorie.subcategorieNames.length * 58.0,
              child: ListView.builder(
                itemCount: widget.categorie.subcategorieNames.length,
                itemBuilder: (BuildContext context, int subcategorieIndex) {
                  return ListTile(
                    title: Text(widget.categorie.subcategorieNames[subcategorieIndex]),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () => BlocProvider.of<CategorieBloc>(context)
                                .add(LoadSubcategorieEvent(context, widget.categorie, widget.categorie.subcategorieNames[subcategorieIndex])),
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.remove_rounded, color: Colors.white70),
                            onPressed: () => _showDeleteSubcategorieDialog(subcategorieIndex),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
