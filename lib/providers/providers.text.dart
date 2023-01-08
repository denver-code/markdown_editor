import 'package:flutter/material.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/providers.dart';
import 'package:markdown_editor/providers/providers.buffer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text/text.dart';

class FontSizeNotifier extends StateNotifier<double> {
  static const persistKey = '__fontSize__';
  final SharedPreferences? pref;
  static const baseSize = 14.0;
  FontSizeNotifier({double? fontSize, this.pref}) : super(fontSize ?? baseSize);

  factory FontSizeNotifier.fromPref(SharedPreferences? pref) {
    final data = pref?.getDouble(persistKey);
    return FontSizeNotifier(fontSize: data, pref: pref);
  }

  @override
  set state(double _state) {
    pref?.setDouble(persistKey, _state);
    super.state = _state;
  }
}

class TextControllerHandler {
  final ProviderRef<void> ref;
  const TextControllerHandler(this.ref);

  AppNotifier get source => ref.read(sourceProvider.notifier);
  TextEditingController? get controller => source.controller;

  void wrap({
    required String left,
    String? right,
  }) {
    final ctl = controller;
    if (ctl == null) return;
    right ??= left;
    final sel = ctl.selection;
    final text = ctl.text;
    final output = [
      sel.textBefore(text),
      left,
      sel.textInside(text),
      right,
      sel.textAfter(text)
    ].join();
    ctl.value = TextEditingValue(
      text: output,
      selection: sel.copyWith(
        baseOffset: sel.baseOffset + left.length,
        extentOffset: sel.extentOffset + left.length,
      ),
    );
    source.immediatelySetBuffer(output);
  }

  void bold() => wrap(left: '**');
  void italic() => wrap(left: '*');
  void strikethrough() => wrap(left: '~~');
  void mathText() => wrap(left: '\$');
  void mathEnvironment(String environment) => wrap(
        left: '\$\$\\begin{$environment}\n',
        right: '\\end{$environment}\$\$',
      );

  void tab({int length = 2}) {
    final ctl = controller;
    if (ctl == null) return;
    final indent = ''.padLeft(length);
    final sel = ctl.selection;
    final text = ctl.text;
    final output = [
      sel.textBefore(text),
      indent,
      sel.textInside(text),
      sel.textAfter(text)
    ].join();
    ctl.value = TextEditingValue(
      text: output,
      selection: sel.copyWith(
        baseOffset: sel.baseOffset + length,
        extentOffset: sel.extentOffset + length,
      ),
    );
    source.immediatelySetBuffer(output);
  }

  Line _currentLine(Text text, TextEditingController ctl) {
    return text.line(text.locationAt(ctl.selection.start).line - 1);
  }

  void selectLine() {
    final ctl = controller;
    if (ctl == null) return;
    final text = Text(ctl.text);
    final line = _currentLine(text, ctl);
    ctl.selection = TextSelection(
      baseOffset: line.start,
      extentOffset: line.end,
    );
  }
}
