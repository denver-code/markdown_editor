import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventHandler {
  final bool ctrl;
  final bool alt;
  final bool meta;
  final bool shift;
  final String? description;
  final PhysicalKeyboardKey key;
  final KeyEventResult? Function(WidgetRef ref, RawKeyEvent event) onEvent;

  const EventHandler({
    required this.key,
    required this.onEvent,
    this.ctrl = false,
    this.alt = false,
    this.meta = false,
    this.shift = false,
    this.description,
  });

  KeyEventResult? handle(RawKeyEvent event, WidgetRef ref) {
    if (event.physicalKey == key &&
        (!ctrl || event.isControlPressed) &&
        (!alt || event.isAltPressed) &&
        (!meta || event.isMetaPressed) &&
        (!shift || event.isShiftPressed)) {
      if (description != null) debugPrint(description);
      return onEvent(ref, event);
    }
    return null;
  }
}
