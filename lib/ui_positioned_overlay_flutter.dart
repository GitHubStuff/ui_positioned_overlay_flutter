library ui_positioned_overlay_flutter;

import 'package:flutter/material.dart';

class PositionedOverlayWidget<T> extends StatefulWidget {
  final GlobalKey triggerKey;
  final Offset offset;
  final Color backgroundColor;
  final Duration popDelay;
  final double opacity;
  final Widget Function(
      BuildContext context, void Function([dynamic result]) dismiss) builder;

  const PositionedOverlayWidget({
    super.key,
    required this.triggerKey,
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.black,
    this.popDelay = const Duration(milliseconds: 5),
    this.opacity = 0.2,
    required this.builder,
  });

  @override
  State<PositionedOverlayWidget<T>> createState() =>
      _PositionedOverlayWidget<T>();
}

class _PositionedOverlayWidget<T> extends State<PositionedOverlayWidget<T>> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_updatePosition);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _pop();
          },
          child: Scaffold(
            backgroundColor: widget.backgroundColor.withOpacity(widget.opacity),
          ),
        );
      },
    );
  }

  void _pop([dynamic result]) {
    Future.delayed(widget.popDelay, () {
      _overlayEntry?.remove();
      Navigator.of(context).pop(result == null ? null : result as T);
    });
  }

  void _updatePosition(_) {
    // Get the position of the ElevatedButton
    final RenderBox renderBox =
        widget.triggerKey.currentContext!.findRenderObject() as RenderBox;
    final Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    // Create an OverlayEntry to display your child widget
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: widgetPosition.dx + widget.offset.dx,
        top: widgetPosition.dy + widget.offset.dy,
        child: widget.builder(context, _pop),
      ),
    );

    // Insert the OverlayEntry into the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }
}
