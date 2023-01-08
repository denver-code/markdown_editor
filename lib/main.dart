import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/color_schemes.dart';
import 'package:markdown_editor/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/screens/editor.dart';
import 'package:markdown_editor/screens/menu.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ayuLight,
              fontFamily: "AvenirNext",
              scaffoldBackgroundColor: ayuLight.background),
          darkTheme: ThemeData(
            colorScheme: specialDark,
            fontFamily: "AvenirNext",
            scaffoldBackgroundColor: specialDark.background,
          ),
          themeMode: ref.watch(themeModeProvider).themeMode,
          home:
              child!, // child! //Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawScreen()));
          routes: {"/editor": (_) => const Editor()},
        );
      },
      child: StatsFl(
          isEnabled: !kReleaseMode,
          align: Alignment.topRight,
          child: const MainMenuScreen()),
    );
  }
}
