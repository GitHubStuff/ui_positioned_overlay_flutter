// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

import 'package:ui_positioned_overlay_flutter/ui_positioned_overlay_flutter.dart';

final GlobalKey _key = GlobalKey();

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeWidget(context),
      floatingActionButton: null,
    );
  }

  Widget homeWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            key: _key,
            width: 200,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.ltmm1024x1024.image(),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result =
                  await Navigator.of(context).push(_createOverlayRoute<int?>());
              debugPrint('Resulter: $result');
            },
            child: const Text('Show New Overlay'),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _createOverlayRoute<T>() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) {
        return UIPositionedOverlayWidget<T>(
          triggerKey: _key,
          offset: const Offset(10, -10),
          builder: (context, dismiss) {
            return SizedBox(
              width: 200,
              height: 100,
              child: Card(
                child: Center(
                  child: GestureDetector(
                      onTap: () {
                        dismiss(11);
                      },
                      child: const Text('Overlay Content')),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
