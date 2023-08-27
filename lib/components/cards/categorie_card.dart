import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '/models/categorie.dart';
import '/models/enums/mode_types.dart';
import '/models/screen_arguments/create_or_edit_categorie_screen_arguments.dart';
import '/models/screen_arguments/create_or_edit_subcategorie_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class CategorieCard extends StatefulWidget {
  final Categorie categorie;
  final int categorieIndex;

  const CategorieCard({
    Key? key,
    required this.categorie,
    required this.categorieIndex,
  }) : super(key: key);

  @override
  State<CategorieCard> createState() => _CategorieCardState();
}

class _CategorieCardState extends State<CategorieCard> {
  void _deleteCategorie(int index) {
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
                  message: 'Kategorie ${widget.categorie.name} wurde erfolgreich gelöscht.',
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
      widget.categorie.deleteCategorie(widget.categorie);
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(widget.categorie.name),
          controlAffinity: ListTileControlAffinity.leading,
          tilePadding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          textColor: Colors.cyanAccent,
          iconColor: Colors.white70,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    Navigator.pushNamed(context, createOrEditCategorieRoute, arguments: CreateOrEditCategorieScreenArguments(widget.categorie.name, widget.categorie.type!)),
              ),
              IconButton(
                icon: const Icon(Icons.remove_rounded),
                onPressed: () => _deleteCategorie(widget.categorieIndex),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () =>
                    Navigator.pushNamed(context, createOrEditSubcategorieRoute, arguments: CreateOrEditSubcategorieScreenArguments(widget.categorie, ModeType.creationMode)),
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
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () =>
                                Navigator.pushNamed(context, createOrEditCategorieRoute, arguments: CreateOrEditSubcategorieScreenArguments(widget.categorie, ModeType.editMode)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_rounded, color: Colors.white70),
                            onPressed: () => _deleteCategorie(widget.categorieIndex),
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
