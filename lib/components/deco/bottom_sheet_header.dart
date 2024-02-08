import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;

  const BottomSheetHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18.0)),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Divider(
              thickness: 1.0,
              endIndent: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
