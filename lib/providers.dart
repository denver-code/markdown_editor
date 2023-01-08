import 'dart:convert';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/providers/providers.autosave.dart';
import 'package:markdown_editor/providers/providers.buffer.dart';
import 'package:markdown_editor/providers/providers.math.dart';
import 'package:markdown_editor/providers/providers.text.dart';
import 'package:markdown_editor/providers/providers.theme.dart';
import 'package:markdown_editor/providers/providers.visiblity.dart';
import 'package:scribble/scribble.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:markdown/markdown.dart' as md;

final sharedPrefsProvider =
    FutureProvider((_) => SharedPreferences.getInstance());
final initializedProvider =
    Provider<bool>((ref) => ref.watch(sharedPrefsProvider).asData != null);

final handlerProvider = Provider((ref) => TextControllerHandler(ref));

final sourceProvider = StateNotifierProvider<AppNotifier, AppModel>((ref) {
  final s = ref.watch(sharedPrefsProvider);

  return AppNotifier.fromPref(s.asData?.value);
});

final dirtyProvider = Provider((ref) {
  final source = ref.watch(sourceProvider);
  final buffers = source.activeBuffers;
  final index = source.currentBufferIndex;
  return buffers[index].dirty;
});

final bufferProvider = Provider((ref) => ref.watch(sourceProvider).buffer);

final astProvider = Provider((ref) {
  final source = ref.watch(bufferProvider);
  final doc = md.Document(
    extensionSet: md.ExtensionSet.gitHubWeb,
    inlineSyntaxes: [MathSyntax(), TaskListSyntax()],
  );
  return doc.parseLines(const LineSplitter().convert(source));
});

// ref.watch(autosaveProvider).index
final autosaveProvider =
    StateNotifierProvider<AutosaveNotifier, AutosaveState>((ref) {
  final s = ref.watch(sharedPrefsProvider);
  return AutosaveNotifier.fromPref(s.asData?.value);
});

final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final s = ref.watch(sharedPrefsProvider);
  return ThemeNotifier.fromPref(s.asData?.value);
});

final themeModeProvider2 =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final s = ref.watch(sharedPrefsProvider);
  return ThemeNotifier.fromPref(s.asData?.value);
});

final visibiiltyProvider =
    StateNotifierProvider<VisibilityNotifier, VisibilityState>((ref) {
  final s = ref.watch(sharedPrefsProvider);
  return VisibilityNotifier.fromPref(s.asData?.value);
});

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final s = ref.watch(sharedPrefsProvider);
  return FontSizeNotifier.fromPref(s.asData?.value);
});

final scribbleProvider = StateNotifierProvider<ScribbleNotifier, ScribbleState>(
    (_) => ScribbleNotifier(maxHistoryLength: 100));

// ------------------------ enum definitions -----------------------------------

enum VisibilityStates { editor, preview, stack }

enum Exports { html, htmlPlain, md }
