import 'package:flutter/material.dart';

///
class AsyncFAB extends FloatingActionButton {
  ///
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
