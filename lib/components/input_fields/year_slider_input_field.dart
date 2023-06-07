import 'package:flutter/material.dart';

import '/components/tab_views/asset_development_statistic_tab_view.dart';

class YearSliderInputField extends StatefulWidget {
  final double years;
  final Function onChanged;

  const YearSliderInputField({
    Key? key,
    required this.years,
    required this.onChanged,
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
      onChanged: (years) => setState(() {
        _years = years;
        //AssetDevelopmentStatisticTabView.of(context)!.years = _years;
      }),
      onChangeEnd: (years) => setState(() {
        widget.onChanged(_years);
      }),
      divisions: 50,
      min: 1,
      max: 50,
      label: _years.toStringAsFixed(0),
    );
  }
}
