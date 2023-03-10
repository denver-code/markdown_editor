import 'package:flutter/material.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisibilityState {
  final VisibilityStates visibiilty;
  final IconData icon;
  final String message;

  const VisibilityState({
    required this.visibiilty,
    required this.icon,
    required this.message,
  });

  static const values = [
    VisibilityState(
      visibiilty: VisibilityStates.editor,
      icon: Icons.edit,
      message: 'Edit',
    ),
    VisibilityState(
      visibiilty: VisibilityStates.preview,
      icon: Icons.visibility,
      message: 'Preview',
    ),
    VisibilityState(
      visibiilty: VisibilityStates.stack,
      icon: Icons.vertical_split,
      message: 'Stack',
    ),
  ];

  static VisibilityState get stack => values[2];

  VisibilityState get next => values[(visibiilty.index + 1) % values.length];

  factory VisibilityState.fromIndex(int index) => values[index];

  bool get editing => visibiilty != VisibilityStates.preview;
  bool get previewing => visibiilty != VisibilityStates.editor;
  bool get doSyncScroll => visibiilty == VisibilityStates.stack;
  bool get sideBySide => visibiilty == VisibilityStates.stack;
}

class VisibilityNotifier extends StateNotifier<VisibilityState> {
  static const persistKey = '__vis__';
  final SharedPreferences? pref;
  VisibilityNotifier({VisibilityState? visibility, this.pref})
      : super(visibility ?? VisibilityState.stack);

  factory VisibilityNotifier.fromPref(SharedPreferences? pref) {
    if (pref == null) return VisibilityNotifier();
    final index =
        pref.getInt(persistKey) ?? VisibilityState.stack.visibiilty.index;
    return VisibilityNotifier(
        visibility: VisibilityState.fromIndex(index), pref: pref);
  }

  VisibilityState next() {
    pref?.setInt(persistKey, state.next.visibiilty.index);
    return state = state.next;
  }
}
