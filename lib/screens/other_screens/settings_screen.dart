import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '/models/intro_screen_state/intro_screen_state_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/hive_consts.dart';
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
            title: const Text('Gefahrenzone', style: TextStyle(color: Colors.redAccent)),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text('Alle Daten löschen'),
                description: const Text('Es werden alle Buchungen, Budgets, Konten und Kategorien gelöscht.\nDie gelöschten Daten können nicht wiederhergestellt werden.'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.replay_rounded),
                title: const Text('Startzustand wiederherstellen'),
                description: const Text(
                    'Es werden alle Buchungen, Budgets, Konten und Kategorien gelöscht. Anschließend werden die Start Kategorien und Konten angelegt.\nDie gelöschten Daten können nicht wiederhergestellt werden.'),
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
                          setHiveMode(value);
                        });
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
                      },
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.restart_alt),
                      title: const Text('Einführungsbildschirm Reset'),
                      onPressed: (_) => showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            content: const Text("Beim nächsten Start der App wird der Einführungsbildschirm erneut angezeigt."),
                            title: const Text("Info"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Abbrechen", style: TextStyle(color: Colors.cyanAccent)),
                              ),
                              TextButton(
                                onPressed: () {
                                  IntroScreenStateRepository introScreenStateRepository = IntroScreenStateRepository();
                                  introScreenStateRepository.setIntroScreenState();
                                  Navigator.pop(context);
                                  Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
                                },
                                child: const Text("OK", style: TextStyle(color: Colors.cyanAccent)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const SettingsSection(tiles: []),
          SettingsSection(
            title: const Text('Rechtliches'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.gpp_good_rounded),
                title: const Text('Datenschutzerklärung'),
                onPressed: (_) => showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: const Text("TODO"),
                      title: const Text("TODO"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK", style: TextStyle(color: Colors.cyanAccent)),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.art_track_rounded),
                title: const Text('Impressum'),
                onPressed: (_) => showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: const Text("TODO"),
                      title: const Text("TODO"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK", style: TextStyle(color: Colors.cyanAccent)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
