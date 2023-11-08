import 'dart:async';

import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

import '../../utils/async_state.dart';

///
class AsyncFloatingActionButton extends FloatingActionButton {
  ///
  const AsyncFloatingActionButton({
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
    return _AsyncFloatingActionButtonBuilder(
      it: this,
      builder: (context, state) {
        return FloatingActionButton(
          key: key,
          onPressed: onPressed != null ? state.press : null,
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
          child: state.async.when(
            data: (_) => child,
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _AsyncFloatingActionButtonBuilder extends StatefulWidget {
  const _AsyncFloatingActionButtonBuilder({
    required this.it,
    required this.builder,
  });

  final FloatingActionButton it;
  final Widget Function(
    BuildContext context,
    AsyncFloatingActionButtonState state,
  ) builder;

  @override
  State<_AsyncFloatingActionButtonBuilder> createState() =>
      AsyncFloatingActionButtonState();
}

///
class AsyncFloatingActionButtonState
    extends AsyncState<_AsyncFloatingActionButtonBuilder, void> {
  /// Invokes [AsyncFloatingActionButton.onPressed] programatically.
  void press() {
    if (widget.it.onPressed != null) {
      _cancelTimer?.cancel();
      async.future = Future(widget.it.onPressed!);
    }
  }

  @override
  void onError(Object error, StackTrace? stackTrace) {
    super.onError(error, stackTrace);
    _cancelTimer?.cancel();
    _cancelTimer = Timer(const Duration(seconds: 3), cancel);
  }

  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return widget.builder(context, this);
      },
    );
  }
}
