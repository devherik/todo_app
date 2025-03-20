import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:minimalist_todo/config/theme_app.dart';
import 'package:minimalist_todo/view/home.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.initFlutter(dir.path);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeApp.themeData,
      home: const Home(title: 'Minimalist TODO App'),
    );
  }

  void showToaster(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
