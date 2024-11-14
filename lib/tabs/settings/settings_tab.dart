import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/auth/login_screen.dart';
import 'package:to_do_app/auth/user_provider.dart';
import 'package:to_do_app/tabs/settings/language.dart';
import 'package:to_do_app/tabs/settings/mode.dart';
import 'package:to_do_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_theme.dart';
import '../tasks/tasks_provider.dart';
import 'package:to_do_app/app_theme.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  List<Lang> langs = [
    Lang(name: 'English', code: 'en'),
    Lang(name: 'العربية', code: 'ar'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Mode> modes = [
      Mode(switchTodark: false, modeName: (AppLocalizations.of(context)!.light)),
      Mode(switchTodark: true, modeName: (AppLocalizations.of(context)!.dark)),
    ];
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // AppBar background container
        Container(
          height: screenHeight * 0.16,
          color: AppTheme.primary,
          width: double.infinity,
        ),

        // Positioned text in AppBar
        PositionedDirectional(
          start: 20,
          child: SafeArea(
            child: Text(
              (AppLocalizations.of(context)!.settings), // Adjust text as needed
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: settingsProvider.isDark
                        ? AppTheme.black
                        : AppTheme.white,
                    fontSize: 22,
                  ),
            ),
          ),
        ),

        // Main content of Settings
        Padding(
          padding:
              EdgeInsets.only(top: screenHeight * 0.16, left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    (AppLocalizations.of(context)!.lang),
                    style: TextStyle(
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          border: Border.all(color: AppTheme.primary),
                        ),
                        child: DropdownButtonHideUnderline(

                          child: DropdownButton<Lang>(
                              style: TextStyle(color: Colors.amber),
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              menuWidth: 200,
                              value: langs.firstWhere((language) =>
                                  language.code == settingsProvider.LangCode),
                              items: langs
                                  .map((language) => DropdownMenuItem<Lang>(
                                        child: Text(
                                          language.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: AppTheme.primary)
                                        ),
                                        value: language,
                                      ))
                                  .toList(),
                              onChanged: (selectedLanguage) {
                                if (selectedLanguage != null) {settingsProvider.ChangeLang(selectedLanguage.code);}
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 19),
              Row(
                children: [
                  Text(
                    (AppLocalizations.of(context)!.mode),
                    style: TextStyle(
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          border: Border.all(color: AppTheme.primary),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Mode>(
                            style: TextStyle(color: Colors.amber),
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            // dropdownColor: AppTheme.primary,
                            // focusColor: AppTheme.red,
                            menuWidth: 200,
                            value: modes.firstWhere(
                              (mode) =>
                                  mode.switchTodark == settingsProvider.isDark,
                            ),
                            items: modes.map((mod) {
                              return DropdownMenuItem<Mode>(
                                value: mod,
                                child: Text(
                                  mod.modeName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: AppTheme.primary),
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedTheme) =>
                                settingsProvider.ChangeTheme(
                              selectedTheme!.switchTodark
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (AppLocalizations.of(context)!.logout),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .UpdateUser(null);
                      Provider.of<TaskProvider>(context, listen: false)
                          .tasks
                          .clear();

                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
