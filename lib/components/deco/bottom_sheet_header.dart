import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final double leftPadding;

  const BottomSheetHeader({
    Key? key,
    required this.title,
    this.leftPadding = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, left: leftPadding),
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
