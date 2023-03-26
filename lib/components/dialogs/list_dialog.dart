import 'package:flutter/material.dart';

import '../../utils/helper_components/scrolling_behavior.dart';

void showListDialog(BuildContext context, String title, List<dynamic> items, TextEditingController textController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 400.0,
          child: ScrollConfiguration(
            behavior: ScrollingBehavior(),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () => {
                    textController.text = items[index],
                    Navigator.pop(context),
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
