import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences prefs;
  static const String key = 'isDarkMode';

  ThemeCubit(this.prefs) : super(prefs.getBool(key) ?? false);

  void toggleTheme() {
    emit(!state);
    prefs.setBool(key, state);
  }
}
