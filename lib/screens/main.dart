import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/internal/internal.handlers.dart';
import 'package:markdown_editor/providers/providers.text.dart';
import 'package:markdown_editor/widgets/app_drawer.dart';
import 'package:markdown_editor/widgets/bottom_bar.dart';
import 'package:markdown_editor/widgets/custom_delimiter.dart';
import 'package:markdown_editor/widgets/custom_markdown.dart';
import 'package:universal_io/io.dart';

import '../formatters.dart';
import '../providers.dart';

class Main extends ConsumerStatefulWidget {
  final String? initialValue;
  const Main({Key? key, this.initialValue}) : super(key: key);

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  static final _isMobile = Platform.isAndroid || Platform.isIOS;
  Timer? timer;

  final previewScrollController = ScrollController();
  final _node = FocusNode();

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _node.dispose();
    previewScrollController.dispose();
  }

  KeyEventResult onKey(FocusNode node, RawKeyEvent event) {
    if (event is! RawKeyUpEvent) return KeyEventResult.ignored;
    KeyEventResult? res;
    for (final handler in handlers) {
      if ((res = handler.handle(event, ref)) != null) {
        return res!;
      }
    }
    return KeyEventResult.ignored;
  }

  Widget buildEditor(BuildContext bc, WidgetRef ref, Widget? _) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (noti) {
        return ref.read(visibiiltyProvider).doSyncScroll
            ? onScrolNotification(noti)
            : false;
      },
      child: FocusScope(
        onKey: onKey,
        child: TextField(
          decoration: const InputDecoration.collapsed(hintText: null),
          maxLines: null,
          expands: true,
          enabled: ref.watch(initializedProvider),
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: ref.watch(fontSizeProvider),
          ),
          controller: ref.watch(sourceProvider.notifier).controller,
          focusNode: _node,
          onChanged: ref.read(sourceProvider.notifier).setBuffer,
          inputFormatters: [
            NewlineFormatter(),
          ],
        ),
      ),
    );
  }

  bool onScrolNotification(ScrollUpdateNotification noti) {
    if (!previewScrollController.hasClients) return false;
    final extent = previewScrollController.position.maxScrollExtent /
        noti.metrics.maxScrollExtent;
    previewScrollController.jumpTo(noti.metrics.pixels * extent);
    return true;
  }

  Widget buildPreview(BuildContext bc, WidgetRef ref, Widget? _) {
    final ast = ref.watch(astProvider);
    return CustomMarkdownWidget(
      ast: ast,
      padding: EdgeInsets.zero,
      controller: previewScrollController,
      lazy: !ref.watch(visibiiltyProvider).doSyncScroll,
      styleSheet:
          MarkdownStyleSheet.fromTheme(Theme.of(bc)).merge(MarkdownStyleSheet(
        textScaleFactor:
            ref.watch(fontSizeProvider) / FontSizeNotifier.baseSize,
        code: const TextStyle(
          fontFamily: 'AvenirNext',
        ),
      )),
    );
  }

  Widget buildPage(BuildContext bc, BoxConstraints cons) {
    final vertical = cons.maxWidth <= 768;
    return Consumer(builder: (bc, ref, _) {
      final vis = ref.watch(visibiiltyProvider);
      final children = <Widget>[
        if (vis.editing)
          Expanded(
            child: Padding(
              padding: vertical
                  ? const EdgeInsets.fromLTRB(16, 10, 16, 8)
                  : _isMobile
                      ? const EdgeInsets.fromLTRB(16, 15, 8, 8)
                      : const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Consumer(builder: buildEditor),
            ),
          ),
        if (vertical && vis.sideBySide) const CustomDelimiter(),
        if (!vertical && vis.sideBySide) const CustomVerticalDelimiter(),
        if (vis.previewing)
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: vertical
                  ? _isMobile
                      ? const EdgeInsets.fromLTRB(16, 5, 16, 0)
                      : const EdgeInsets.fromLTRB(16, 16, 16, 8)
                  : _isMobile
                      ? const EdgeInsets.fromLTRB(8, 5, 16, 8)
                      : const EdgeInsets.fromLTRB(8, 16, 16, 8),
              child: Consumer(builder: buildPreview),
            ),
          )
      ];
      return Column(
        children: [
          if (vertical)
            ...children.reversed
          else
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          const BottomBar(),
        ],
      );
    });
  }

  @override
  Widget build(context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        endDrawer: const AppDrawer(),
        body: SafeArea(
          child: LayoutBuilder(builder: buildPage),
        ),
      ),
    );
  }
}
