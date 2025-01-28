import 'dart:async';

import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

import '../../configs/async_config.dart';
import '../../utils/async_state.dart';
import '../async/async.dart';

///
class AsyncButtonBuilder extends StatefulWidget {
  ///
  const AsyncButtonBuilder({
    super.key,
    this.config = const AsyncButtonConfig(),
    this.configurator,
    this.onPressed,
    this.onLongPress,
    required this.child,
    required this.builder,
  });

  /// The onPressed callback.
  final VoidCallback? onPressed;

  /// The onLongPress callback.
  final VoidCallback? onLongPress;

  /// The config of this button.
  final AsyncButtonConfig config;

  /// The optional configurator of this button.
  ///
  /// If defined, merges [config] with [configurator] result. Useful for inheritance.
  final AsyncButtonConfigurator? configurator;

  /// The child of [AsyncButtonBuilder].
  final Widget child;

  /// The builder of [AsyncButtonBuilder].
  final AsyncButtonStateBuilder builder;

  @override
  State<AsyncButtonBuilder> createState() => AsyncButtonBuilderState();
}

/// The [AsyncState] of [AsyncButtonBuilder].
class AsyncButtonBuilderState extends AsyncState<AsyncButtonBuilder, void> {
  AsyncButtonResolvedConfig get _config {
    return widget.config
        .merge(widget.configurator?.call(context))
        .merge(Async.of(context).buttonConfig)
        .resolve();
  }

  /// Invokes [AsyncButtonBuilder.onPressed] programatically.
  void press() {
    if (widget.onPressed != null) {
      async.future = Future(widget.onPressed!);
    }
  }

  /// Returns either [press] or null.
  VoidCallback? get onPressed => widget.onPressed != null ? press : null;

  /// Invokes [AsyncButtonBuilder.onLongPress] programatically.
  void longPress() {
    if (widget.onLongPress != null) {
      async.future = Future(widget.onLongPress!);
    }
  }

  /// Returns either [longPress] or null.
  VoidCallback? get onLongPress =>
      widget.onLongPress != null ? longPress : null;

  void _setSize(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _size ??= context.size);
  }

  void _reset() {
    async.value = const AsyncSnapshot.nothing();
  }

  @override
  void onSnapshot(AsyncSnapshot<void> snapshot) {
    _successTimer?.cancel();
    _errorTimer?.cancel();

    // resets button state after success/error duration
    snapshot.whenOrNull(
      data: (_) => _successTimer = Timer(_config.successDuration, _reset),
      error: (e, s) => _errorTimer = Timer(_config.errorDuration, _reset),
    );
  }

  @override
  void dispose() {
    _successTimer?.cancel();
    _errorTimer?.cancel();
    super.dispose();
  }

  Timer? _successTimer;
  Timer? _errorTimer;
  Size? _size;

  @override
  Widget build(BuildContext context) {
    final snapshot = async.snapshot;

    final child = Builder(
      builder: (context) {
        if (_size == null) _setSize(context);

        var child = snapshot.when(
          none: () => widget.child,
          loading: () => _config.loadingBuilder(context),
          error: (e, s) => _config.errorBuilder(context, e, s),
          data: (_) => _config.successBuilder?.call(context) ?? widget.child,
        );

        if (_config.animateSize) {
          child = AnimatedSize(
            alignment: _config.animatedSizeConfig.alignment,
            duration: _config.animatedSizeConfig.duration,
            reverseDuration: _config.animatedSizeConfig.reverseDuration,
            curve: _config.animatedSizeConfig.curve,
            clipBehavior: _config.animatedSizeConfig.clipBehavior,
            child: child,
          );
        }

        return SizedBox(
          height: _config.keepHeight ? _size?.height : null,
          width: _config.keepWidth ? _size?.width : null,
          child: child,
        );
      },
    );

    return AnimatedTheme(
      duration: _config.styleDuration,
      curve: _config.styleCurve,
      data: snapshot.when(
        none: () => Theme.of(context),
        loading: () => _config.loadingTheme(context),
        error: (e, s) => _config.errorTheme(context),
        data: (_) => _config.successTheme(context),
      ),
      child: widget.builder(context, this, child),
    );
  }
}

/// Signature for a function that creates a [Widget] for [AsyncButtonBuilder].
typedef AsyncButtonStateBuilder = Widget Function(
  BuildContext context,
  AsyncButtonBuilderState state,
  Widget child,
);

/// Signature for a function that creates a [AsyncButtonConfig].
typedef AsyncButtonConfigurator = AsyncButtonConfig? Function(
  BuildContext context,
);
