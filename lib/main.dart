import 'package:flutter/material.dart';
import 'package:note_app/Pages/home.dart';
import 'package:note_app/Pages/edit_note.dart';
import 'package:note_app/Pages/new_note.dart';
import 'package:note_app/Pages/menu.dart';
import 'package:note_app/Pages/search.dart';
import 'package:note_app/Pages/setting.dart';
import 'package:note_app/services/persist_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPrefs.init();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/edit': (context) => const EditNote(),
        '/new': (context) => const NewNote(),
        '/menu': (context) => const MenuPage(),
        '/setting': (context) => const SettingPage(),
        '/search': (context) => const SearchPage()
      },
    ),
  );
}
