import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:settings_ui/settings_ui.dart';

import '/main.dart';
import '/models/account/account_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/intro_screen_state/intro_screen_state_repository.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import '/utils/consts/global_consts.dart';
import '/utils/consts/hive_consts.dart';
import '/utils/consts/route_consts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void deleteAllData() async {
    var bookingBox = await Hive.openBox(bookingsBox);
    var accountBox = await Hive.openBox(accountsBox);
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    var categorieBox = await Hive.openBox(categoriesBox);
    var budgetBox = await Hive.openBox(budgetsBox);
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    var globalState = await Hive.openBox(globalStateBox);
    var introScreen = await Hive.openBox(introScreenBox);

    bookingBox.deleteFromDisk();
    accountBox.deleteFromDisk();
    primaryAccountBox.deleteFromDisk();
    categorieBox.deleteFromDisk();
    budgetBox.deleteFromDisk();
    subbudgetBox.deleteFromDisk();
    defaultBudgetBox.deleteFromDisk();
    globalState.deleteFromDisk();
    introScreen.deleteFromDisk();

    GlobalStateRepository globalStateRepository = GlobalStateRepository();
    globalStateRepository.create();
  }

  // Hive Boxen auf Prod oder Demo Modus setzen
  void _initializeHiveValues() async {
    setHiveMode(!demoMode);
    var categorieBox = await Hive.openBox(categoriesBox);
    if (categorieBox.isNotEmpty) {
      return;
    }
    GlobalStateRepository globalStateRepository = GlobalStateRepository();
    globalStateRepository.create();
    AccountRepository accountRepository = AccountRepository();
    accountRepository.createStartAccounts();
    CategorieRepository categorieRepository = CategorieRepository();
    categorieRepository.createStartCategories();
    PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
    primaryAccountRepository.createStartPrimaryAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: SettingsList(
        darkTheme: const SettingsThemeData(settingsListBackground: Color(0xff112025)),
        sections: [
          SettingsSection(
            title: const Text('Gefahrenzone', style: TextStyle(color: Colors.redAccent)),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text('Alle Daten löschen'),
                description: const Text(
                    'Es werden alle Buchungen, Budgets, Konten und Kategorien gelöscht.\nDie gelöschten Daten können nicht wiederhergestellt werden.'),
                onPressed: (_) => {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Text(
                            'Wollen Sie wirklich alle Daten unwiderruflich löschen?\nDie gelöschten Daten können nicht wiederhergestellt werden!'),
                        title: const Text('Warnung'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Nein', style: TextStyle(color: Colors.cyanAccent)),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAllData();
                              Navigator.pop(context);
                              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
                            },
                            child: const Text('Ja', style: TextStyle(color: Colors.cyanAccent)),
                          ),
                        ],
                      );
                    },
                  ),
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.replay_rounded),
                title: const Text('Startzustand wiederherstellen'),
                description: const Text(
                    'Es werden alle Buchungen, Budgets, Konten und Kategorien gelöscht. Anschließend werden die Start Kategorien und Konten angelegt.\nDie gelöschten Daten können nicht wiederhergestellt werden.'),
                onPressed: (_) => {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Text(
                            "Wollen Sie wirklich alle Daten unwiderruflich löschen? Die Kategorien und Konten werden auf den Startzustand zurückgesetzt.\nDie gelöschten Daten können nicht wiederhergestellt werden!"),
                        title: const Text("Warnung"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Nein", style: TextStyle(color: Colors.cyanAccent)),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAllData();
                              Navigator.pop(context);
                              Navigator.popAndPushNamed(context, introductionRoute);
                            },
                            child: const Text("Ja", style: TextStyle(color: Colors.cyanAccent)),
                          ),
                        ],
                      );
                    },
                  ),
                },
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
                      onToggle: (bool isDemoMode) {
                        setState(() {
                          _initializeHiveValues();
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
