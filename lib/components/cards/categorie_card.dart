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
          leading: const SizedBox.shrink(),
          controlAffinity: ListTileControlAffinity.leading,
          textColor: Colors.white,
          iconColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: IconButton(
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.white),
                  onPressed: () => _showDeleteCategorieDialog(),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        widget.categorie.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    widget.categorie.subcategorieNames.isEmpty
                        ? const Text('-', style: TextStyle(fontSize: 12.0, color: Colors.grey))
                        : Text(
                            _getSubcategorieNames(widget.categorie.subcategorieNames),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => BlocProvider.of<CategorieBloc>(context).add(LoadCategorieEvent(context, widget.categorie.index)),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
                      onPressed: () => BlocProvider.of<CategorieBloc>(context).add(InitializeSubcategorieEvent(context, widget.categorie)),
                    ),
                  ],
                ),
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.white),
                            onPressed: () => _showDeleteSubcategorieDialog(subcategorieIndex),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.categorie.subcategorieNames[subcategorieIndex],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => BlocProvider.of<CategorieBloc>(context)
                                    .add(LoadSubcategorieEvent(context, widget.categorie, widget.categorie.subcategorieNames[subcategorieIndex])),
                              ),
                            ],
                          ),
                        ),
                      ],
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
