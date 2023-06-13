import 'package:flutter/material.dart';

import '/components/tab_views/asset_development_statistic_tab_view.dart';

class YearSliderInputField extends StatefulWidget {
  double years;
  final Function onChangeEnd;

  YearSliderInputField({
    Key? key,
    required this.years,
    required this.onChangeEnd,
  }) : super(key: key);

  @override
  State<YearSliderInputField> createState() => _YearSliderInputFieldState();
}

class _YearSliderInputFieldState extends State<YearSliderInputField> {
  double _years = 1;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _years,
      onChanged: (years) {
        setState(() => _years = years);
      },
      onChangeEnd: (double years) => setState(() {
        widget.years = years;
        widget.onChangeEnd;
      }),
      divisions: 50,
      min: 1,
      max: 50,
      label: _years.toStringAsFixed(0),
    );
  }
}
