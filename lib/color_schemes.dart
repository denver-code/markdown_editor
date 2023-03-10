import 'package:flutter/material.dart';
import 'package:markdown_editor/internal/internal.hex2color.dart';

const ayuFg = Color(0xff575f66);

/// See [ayu-colors](https://github.com/ayu-theme/ayu-colors)
const ayuDark = ColorScheme(
  primary: Color(0xff39bae6), // syntax.tag
  primaryContainer: Color(0xff59c2ff), // syntax.entity
  secondary: Color(0xffe6b450), // common.accent
  secondaryContainer: Color(0xffffb454), // syntax.func
  surface: Color(0xff273747), // ui.selection.bg
  background: Color(0xff0a0e14), // common.bg
  error: Color(0xffff3333), // syntax.error
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Color(0xffb3b1ad),
  onBackground: Color(0xffb3b1ad), // common.fg
  onError: Colors.black, // common.fg
  brightness: Brightness.dark,
);

final specialDark = ColorScheme(
  primary: HexColor.fromHex("#BF5A69"), // syntax.tag
  primaryContainer: const Color.fromARGB(255, 217, 74, 74), // syntax.entity
  secondary: const Color.fromARGB(255, 123, 230, 80), // common.accent
  secondaryContainer: const Color.fromARGB(255, 84, 255, 118), // syntax.func
  surface: const Color.fromARGB(255, 33, 33, 33), // ui.selection.bg
  background: HexColor.fromHex("#1A1C1C"), // common.bg
  error: const Color(0xffff3333), // syntax.error
  onPrimary: const Color.fromARGB(255, 255, 0, 0),
  onSecondary: Colors.black,
  onSurface: const Color.fromARGB(255, 180, 180, 180),
  onBackground: const Color.fromARGB(255, 232, 232, 232), // common.fg
  onError: Colors.black, // common.fg
  brightness: Brightness.dark,
);

const ayuLight = ColorScheme(
  primary: Color(0xff55b4d4),
  primaryContainer: Color(0xff399ee6),
  secondary: Color(0xffff9940),
  secondaryContainer: Color(0xfff2ae49),
  surface: Color(0xffe7e8e9),
  background: Color(0xfffafafa),
  error: Color(0xfff51818),
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Color(0xff575f66),
  onBackground: Color(0xff575f66),
  onError: Colors.black,
  brightness: Brightness.light,
);
