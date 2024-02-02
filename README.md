# Intro

<!--
The comments below are from the Flutter/Dart package generation. Feel free to use or ignore
-->

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This package takes 'key'ed widget (a global key), and can place a child widget overlayed and positioned on/near the parent widget.

The area around the child is tappable and will dismiss the child (returning null), the child can also dismiss the over and return a value.

## Getting started

Install in **pubspec.yaml**

```yaml
dependencies:
  ui_positioned_overlay_flutter:
    git: https://github.com/GitHubStuff/ui_positioned_overlay_flutter.git
```

## Usage

See **/example** folder for a detailed example including use of *GlobalKey*

***NOTE:***

Use of this widget required creating a **PageRouteBuilder**. The example shows the requiremens and fields to add the positioning widget to the widget-true at the correct position.

## Widget Declaration

```dart
class PositionedOverlayWidget<T> extends StatefulWidget {
  final GlobalKey triggerKey;
  final Offset offset;
  final Color backgroundColor;
  final double opacity;
  final Widget Function(
      BuildContext context, void Function([dynamic result]) dismiss) builder;
  const PositionedOverlayWidget({
    super.key,
    required this.triggerKey,
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.black,
    this.opacity = 0.2,
    required this.builder,
  });
```

## Finally

Be kind to each other!
