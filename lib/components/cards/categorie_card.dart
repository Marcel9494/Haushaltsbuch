import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:haushaltsbuch/models/categorie/categorie_repository.dart';

import '/models/enums/mode_types.dart';
import '/models/categorie/categorie_model.dart';
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

  void _deleteSubcategorie(int index) {
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
                  title: 'Unterkategorie wurde gelöscht',
                  message: 'Unterkategorie ${widget.categorie.subcategorieNames[index]} wurde erfolgreich gelöscht.',
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
    CategorieRepository categorieRepository = CategorieRepository();
    setState(() {
      categorieRepository.deleteSubcategorie(widget.categorie, widget.categorie.subcategorieNames[index]);
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
          title: Padding(
            padding: widget.categorie.subcategorieNames.isEmpty ? const EdgeInsets.only(left: 56.0) : EdgeInsets.zero,
            child: Text(widget.categorie.name),
          ),
          controlAffinity: widget.categorie.subcategorieNames.isEmpty ? null : ListTileControlAffinity.leading,
          tilePadding: const EdgeInsets.only(left: 8.0),
          textColor: widget.categorie.subcategorieNames.isEmpty ? Colors.white : Colors.cyanAccent,
          iconColor: Colors.white70,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    Navigator.pushNamed(context, createOrEditCategorieRoute, arguments: CreateOrEditCategorieScreenArguments(widget.categorie.name, widget.categorie.type!)),
              ),
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.remove_rounded),
                onPressed: () => _deleteCategorie(widget.categorieIndex),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 4.0, right: 12.0),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.add_rounded),
                onPressed: () =>
                    Navigator.pushNamed(context, createOrEditSubcategorieRoute, arguments: CreateOrEditSubcategorieScreenArguments(widget.categorie, ModeType.creationMode, -1)),
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
                            onPressed: () => Navigator.pushNamed(context, createOrEditSubcategorieRoute,
                                arguments: CreateOrEditSubcategorieScreenArguments(widget.categorie, ModeType.editMode, subcategorieIndex)),
                          ),
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.remove_rounded, color: Colors.white70),
                            onPressed: () => _deleteSubcategorie(subcategorieIndex),
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
