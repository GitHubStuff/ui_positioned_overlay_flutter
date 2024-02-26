/// A Flutter package for creating an overlay widget that can be positioned over another widget.
library ui_positioned_overlay_flutter;

import 'package:flutter/material.dart';

/// A widget that creates a positioned overlay with customizable properties.
/// It uses a GlobalKey to position itself relative to another widget or explicit coordinates.
class UIPositionedOverlayWidget<T> extends StatefulWidget {
  /// GlobalKey to find the widget to overlay. If null, `dx` and `dy` must be provided.
  final GlobalKey? triggerKey;

  /// Background color of the overlay.
  final Color backgroundColor;

  /// Opacity of the overlay layer.
  final double layerOpacity;

  /// Duration of the fade animation for the overlay.
  final Duration fadeDuration;

  /// Offset from the position determined by `triggerKey` or `dx` and `dy`.
  final Offset offset;

  /// Explicit x-coordinate to position the overlay. Required if `triggerKey` is null.
  final double? dx;

  /// Explicit y-coordinate to position the overlay. Required if `triggerKey` is null.
  final double? dy;

  /// Builder function to create the overlay widget. Provides context and a dismiss function.
  final Widget Function(
      BuildContext context, void Function([dynamic result]) dismiss) builder;

  /// Constructs a UIPositionedOverlayWidget.
  /// Asserts that either `triggerKey` or both `dx` and `dy` are provided.
  const UIPositionedOverlayWidget({
    super.key,
    this.triggerKey,
    this.dx,
    this.dy,
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.black,
    this.layerOpacity = 0.2,
    this.fadeDuration = const Duration(milliseconds: 300),
    required this.builder,
  }) : assert(triggerKey != null || (dx != null && dy != null),
            "Either triggerKey or both dx and dy must be provided.");

  @override
  State<UIPositionedOverlayWidget<T>> createState() =>
      _UIPositionedOverlayWidget<T>();
}

/// Private State class for UIPositionedOverlayWidget.
/// Manages the overlay entry and animations.
class _UIPositionedOverlayWidget<T> extends State<UIPositionedOverlayWidget<T>>
    with TickerProviderStateMixin {
  /// The OverlayEntry for the widget.
  OverlayEntry? overlayEntry;

  /// Controller for the fade animation.
  late final AnimationController controller;

  /// The fade animation.
  late final Animation<double> animation;

  /// Result to be popped when the overlay is dismissed.
  T? poppedResult;

  @override
  void initState() {
    super.initState();
    // Schedules the overlay update after the layout phase.
    WidgetsBinding.instance.addPostFrameCallback(updatePosition);
    // Initializes the animation controller and listener.
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
          onTap: () => pop(),
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

  /// Handles the pop action for the overlay.
  void pop([dynamic result]) {
    poppedResult = result;
    controller.reverse();
  }

  /// Updates the overlay position based on the provided `dx`, `dy`, or `triggerKey`.
  void updatePosition(_) {
    double left, top;

    if (widget.dx != null && widget.dy != null) {
      // Use dx and dy directly if provided.
      left = widget.dx!;
      top = widget.dy!;
    } else {
      // Otherwise, calculate position based on `triggerKey`.
      final RenderBox renderBox =
          widget.triggerKey!.currentContext!.findRenderObject() as RenderBox;
      final Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
      left = widgetPosition.dx;
      top = widgetPosition.dy;
    }

    // Adjust position by offset.
    left += widget.offset.dx;
    top += widget.offset.dy;

    // Create and insert the overlay entry.
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: widget.builder(context, pop),
            );
          },
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    controller.forward();
  }
}
