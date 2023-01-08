import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_editor/providers.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  final String? initialValue;
  const MainMenuScreen({Key? key, this.initialValue}) : super(key: key);

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  final TextEditingController _bufferNameController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        _bufferNameController.clear();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Create"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/editor");
        ref
            .read(sourceProvider.notifier)
            .newBuffer(bufferName: _bufferNameController.text);
        _bufferNameController.clear();
      },
    );
    Widget skipButton = TextButton(
      child: const Text("Skip"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/editor");
        ref.read(sourceProvider.notifier).newBuffer(bufferName: "New Buffer");
        _bufferNameController.clear();
      },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Name For Your Note'),
            content: TextField(
              controller: _bufferNameController,
              decoration: const InputDecoration(
                  hintText: "Choose Name For Your Note Buffer"),
            ),
            actions: <Widget>[
              cancelButton,
              // skipButton,
              continueButton,
            ],
          );
        });
  }

  Widget buildNavbar(BuildContext bc, WidgetRef ref, Widget? _) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Icon(
              Icons.circle,
              size: 20.0,
              color: Theme.of(bc).colorScheme.primary,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    "Notes",
                    style: TextStyle(fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildMenu(BuildContext bc, WidgetRef ref, Widget? _) {
    return CustomScrollView(slivers: [
      Consumer(builder: (bc, ref, _) {
        final prov = ref.watch(sourceProvider);
        final buffers = prov.activeBuffers;
        // final activeIndex = prov.currentBufferIndex;
        return SliverPadding(
          padding: const EdgeInsets.only(top: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (bc, idx) {
                final buffer = buffers[idx];
                return Column(
                  children: [
                    ListTile(
                      title: Text(buffer.title),
                      // selected: idx == activeIndex,
                      onTap: () {
                        ref.read(sourceProvider.notifier).switchBuffer(idx);
                        Navigator.of(bc).pushNamed("/editor");
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          ref.read(sourceProvider.notifier).removeBuffer(idx);
                        },
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
              childCount: buffers.length,
            ),
          ),
        );
      }),
    ]);
  }

  Widget buildPage(BuildContext bc, BoxConstraints cons) {
    return Consumer(builder: (bc, ref, _) {
      final children = <Widget>[
        Consumer(builder: buildNavbar),
        const Divider(),
        Expanded(child: Consumer(builder: buildMenu)),
      ];
      return Column(
        children: [
          Expanded(
            child: Column(
              children: children,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext bc) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: LayoutBuilder(builder: buildPage),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: const Icon(
          Icons.add_rounded,
          size: 45,
        ),
        backgroundColor: Theme.of(bc).colorScheme.primary,
        onPressed: () {
          setState(() {
            _displayTextInputDialog(bc);
          });
        },
      ),
    );
  }
}
