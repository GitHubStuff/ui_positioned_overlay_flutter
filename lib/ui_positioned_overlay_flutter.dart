library ui_positioned_overlay_flutter;

import 'package:flutter/material.dart';

class PositionedOverlayWidget<T> extends StatefulWidget {
  final GlobalKey triggerKey;
  final Color backgroundColor;
  final double layerOpacity;
  final Duration fadeDuration;
  final Offset offset;
  final Widget Function(
      BuildContext context, void Function([dynamic result]) dismiss) builder;

  const PositionedOverlayWidget({
    super.key,
    required this.triggerKey,
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.black,
    this.layerOpacity = 0.2,
    this.fadeDuration = const Duration(milliseconds: 300),
    required this.builder,
  });

  @override
  State<PositionedOverlayWidget<T>> createState() =>
      _PositionedOverlayWidget<T>();
}

class _PositionedOverlayWidget<T> extends State<PositionedOverlayWidget<T>>
    with TickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  late final AnimationController controller;
  late final Animation<double> animation;
  T? poppedResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_updatePosition);
    controller = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    controller.addStatusListener((status) {
      if (AnimationStatus.dismissed == status) {
        overlayEntry?.remove();
        Navigator.of(context)
            .pop(poppedResult == null ? null : poppedResult as T);
      }
    });
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// Tap on the background to dismiss the overlay
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _pop(),
          child: Scaffold(
            backgroundColor:
                widget.backgroundColor.withOpacity(widget.layerOpacity),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _pop([dynamic result]) {
    poppedResult = (result == null ? null : result as T);
    controller.reverse(); //Start fade-out
  }

  void _updatePosition(_) {
    /// Get the position of the calling widget from the key
    final RenderBox renderBox =
        widget.triggerKey.currentContext!.findRenderObject() as RenderBox;
    final Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

    /// Create an OverlayEntry to display the child widget
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: widgetPosition.dx + widget.offset.dx,
        top: widgetPosition.dy + widget.offset.dy,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: widget.builder(context, _pop),
            );
          },
        ),
      ),
    );

    /// Insert the OverlayEntry into the overlay
    Overlay.of(context).insert(overlayEntry!);
    controller.forward(); //Start fade-in
  }
}
