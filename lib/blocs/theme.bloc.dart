import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:countryapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOptions { LIGHT, DARK }

class ThemeBloc implements BlocBase {
  String themeActive;

  ThemeBloc() {
    getTheme().then((f) => setTheme(f));
  }

  BehaviorSubject<ThemeData> _themeController = BehaviorSubject();
  Stream<ThemeData> get theme => _themeController.stream;

  List<ThemeData> _availableThemes = [
    ThemeData(backgroundColor: Color(bg_dark)),
    ThemeData(backgroundColor: Color(bg_light)),
  ];

  toogleTheme() {
    if (themeActive == ThemeOptions.DARK.toString()) {
      setTheme(ThemeOptions.LIGHT);
    } else if (themeActive == ThemeOptions.LIGHT.toString()) {
      setTheme(ThemeOptions.DARK);
    }
  }

  setTheme(ThemeOptions option) {
    switch (option) {
      case ThemeOptions.DARK:
        _themeController.add(_availableThemes[0]);
        _saveState(option.toString());
        themeActive = option.toString();
        break;
      case ThemeOptions.LIGHT:
        _themeController.add(_availableThemes[1]);
        _saveState(option.toString());
        themeActive = option.toString();
        break;
    }
  }

  Future<ThemeOptions> getTheme() async {
    ThemeOptions store;

    await SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("themeSelected")) {
        String themeStore = prefs.getString("themeSelected");

        if (themeStore == ThemeOptions.DARK.toString()) {
          store = ThemeOptions.DARK;
        } else if (themeStore == ThemeOptions.LIGHT.toString()) {
          store = ThemeOptions.LIGHT;
        }
      } else {
        store = ThemeOptions.DARK;
      }
    });

    return store;
  }

  _saveState(value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("themeSelected", value);
    });
  }

  @override
  void dispose() {
    _themeController.close();
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
}