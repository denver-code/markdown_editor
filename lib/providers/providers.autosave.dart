import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutosaveState {
  final bool value;
  final String message;
  final int stateIndex;
  const AutosaveState({
    required this.value,
    required this.message,
    required this.stateIndex,
  });

  static const values = [
    AutosaveState(
      value: false,
      stateIndex: 0,
      message: "Autosave OFF",
    ),
    AutosaveState(
      value: true,
      stateIndex: 1,
      message: "Autosave ON",
    )
  ];

  static AutosaveState get system => values[0];

  AutosaveState get next => values[(stateIndex + 1) % values.length];

  static AutosaveState fromIndex(int index) => values[index];
}

class AutosaveNotifier extends StateNotifier<AutosaveState> {
  static const persistKey = 'as';
  final SharedPreferences? pref;
  AutosaveNotifier({AutosaveState? autosave, this.pref})
      : super(autosave ?? AutosaveState.system);

  factory AutosaveNotifier.fromPref(SharedPreferences? pref) {
    if (pref == null) return AutosaveNotifier();
    return AutosaveNotifier(autosave: stateOf(pref), pref: pref);
  }

  AutosaveState next() {
    pref?.setInt(persistKey, state.next.stateIndex);
    return state = state.next;
  }

  static AutosaveState stateOf(SharedPreferences pref) {
    final index = pref.getInt(persistKey) ?? AutosaveState.system.stateIndex;
    return AutosaveState.fromIndex(index);
  }
}
