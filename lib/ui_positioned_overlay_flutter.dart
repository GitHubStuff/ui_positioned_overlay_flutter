library ui_positioned_overlay_flutter;

import 'package:flutter/material.dart';

class PositionedOverlayWidget<T> extends StatefulWidget {
  final GlobalKey? triggerKey; // Make triggerKey nullable
  final Color backgroundColor;
  final double layerOpacity;
  final Duration fadeDuration;
  final Offset offset;
  final double? dx; // Added dx position
  final double? dy; // Added dy position
  final Widget Function(
      BuildContext context, void Function([dynamic result]) dismiss) builder;

  const PositionedOverlayWidget({
    super.key,
    this.triggerKey, // triggerKey is now nullable
    this.dx, // Initialize dx
    this.dy, // Initialize dy
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.black,
    this.layerOpacity = 0.2,
    this.fadeDuration = const Duration(milliseconds: 300),
    required this.builder,
  }) : assert(triggerKey != null || (dx != null && dy != null),
            "Either triggerKey or both dx and dy must be provided.");

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
        Navigator.of(context).pop(poppedResult);
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
    poppedResult = result;
    controller.reverse();
  }

  void _updatePosition(_) {
    double left, top;

    if (widget.dx != null && widget.dy != null) {
      // Use dx and dy directly
      left = widget.dx!;
      top = widget.dy!;
    } else {
      // Fallback to triggerKey if dx and dy are not available
      final RenderBox renderBox =
          widget.triggerKey!.currentContext!.findRenderObject() as RenderBox;
      final Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
      left = widgetPosition.dx;
      top = widgetPosition.dy;
    }

    left += widget.offset.dx;
    top += widget.offset.dy;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
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

    Overlay.of(context).insert(overlayEntry!);
    controller.forward();
  }
}
