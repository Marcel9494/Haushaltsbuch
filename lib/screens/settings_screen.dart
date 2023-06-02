import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/settings/settings.dart';
import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Allgemein'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text('Alle Daten löschen'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.replay_rounded),
                title: const Text('Daten zurücksetzen'),
              ),
            ],
          ),
          adminMode
              ? SettingsSection(
                  title: const Text('Admin'),
                  tiles: <SettingsTile>[
                    SettingsTile.switchTile(
                      leading: const Icon(Icons.developer_mode),
                      title: const Text('Demo Modus'),
                      initialValue: demoMode,
                      onToggle: (bool value) {
                        setState(() {
                          demoMode = value;
                          print(demoMode);
                        });
                        Navigator.pop(context);
                        Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
                      },
                    ),
                  ],
                )
              : const SettingsSection(tiles: []),
        ],
      ),
    );
  }
}
