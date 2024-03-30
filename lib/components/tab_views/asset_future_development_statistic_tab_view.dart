import 'package:flutter/material.dart';

// TODO
// Für später: Ist in der aktuellen App Version nicht freigeschalten
// wird in einer späteren App Version implementiert und freigeschalten.
class AssetFutureDevelopmentStatisticTabView extends StatefulWidget {
  const AssetFutureDevelopmentStatisticTabView({Key? key}) : super(key: key);

  @override
  State<AssetFutureDevelopmentStatisticTabView> createState() => _AssetFutureDevelopmentStatisticTabViewState();
}

class _AssetFutureDevelopmentStatisticTabViewState extends State<AssetFutureDevelopmentStatisticTabView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Zukünftige Vermögensentwicklung Statistiken'),
          Text('Coming Soon'),
        ],
      ),
    );
  }
}
