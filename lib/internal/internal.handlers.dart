import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers.dart';
import 'internal.event.handler.dart';

final handlers = <EventHandler>[
  EventHandler(
    key: PhysicalKeyboardKey.tab,
    ctrl: true,
    description: 'Next buffer',
    onEvent: (ref, _) {
      ref.read(sourceProvider.notifier).nextBuffer();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.tab,
    onEvent: (ref, _) {
      ref.read(handlerProvider).tab();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyL,
    ctrl: true,
    description: 'Select line',
    onEvent: (ref, _) {
      ref.read(handlerProvider).selectLine();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyM,
    ctrl: true,
    shift: true,
    description: 'Insert math environment',
    onEvent: (ref, _) {
      ref.read(handlerProvider).mathEnvironment('aligned');
      return KeyEventResult.handled;
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyM,
    ctrl: true,
    description: 'Math block (text)',
    onEvent: (ref, event) {
      ref.read(handlerProvider).mathText();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyB,
    ctrl: true,
    description: 'Bold',
    onEvent: (ref, _) {
      ref.read(handlerProvider).bold();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyI,
    ctrl: true,
    description: 'Italic',
    onEvent: (ref, _) {
      ref.read(handlerProvider).italic();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyS,
    alt: true,
    description: 'Bold',
    onEvent: (ref, _) {
      ref.read(handlerProvider).strikethrough();
    },
  ),
  EventHandler(
    key: PhysicalKeyboardKey.keyS,
    ctrl: true,
    description: 'Save',
    onEvent: (ref, _) {
      ref.read(sourceProvider.notifier).save();
    },
  ),
];
