import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_async/src/async_controller.dart';
import 'package:flutter_async/src/widgets/async_state.dart';

class AsyncFAB extends FloatingActionButton {
  const AsyncFAB({
    super.key,
    super.onPressed,
    super.mouseCursor,
    super.mini,
    super.shape,
    super.clipBehavior,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.disabledElevation,
    super.focusElevation,
    super.hoverElevation,
    super.highlightElevation,
    super.autofocus,
    super.materialTapTargetSize,
    super.enableFeedback,
    super.tooltip,
    super.foregroundColor,
    super.backgroundColor,
    super.elevation,
    super.focusNode,
    super.heroTag,
    super.child,
    super.isExtended,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: key,
      onPressed: onPressed,
      mouseCursor: mouseCursor,
      mini: mini,
      shape: shape,
      clipBehavior: clipBehavior,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      disabledElevation: disabledElevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      autofocus: autofocus,
      materialTapTargetSize: materialTapTargetSize,
      enableFeedback: enableFeedback,
      tooltip: tooltip,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      elevation: elevation,
      focusNode: focusNode,
      heroTag: heroTag,
      isExtended: isExtended,
      child: child,
    );
  }
}

class FabAsync extends StatefulWidget implements AsyncWidget {
  const FabAsync({
    super.key,
    this.controller,
    this.listenables = const [],
  });

  @override
  State<FabAsync> createState() => _FabAsyncState();

  @override
  final AsyncController? controller;

  @override
  final List<ValueListenable<bool>> listenables;
}

class _FabAsyncState extends State<FabAsync> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
