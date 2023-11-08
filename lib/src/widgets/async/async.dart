import 'package:flutter/material.dart';

import '../../configs/async_config.dart';
import '../../utils/adaptive_theme.dart';
import '../async_indicator/async_indicator.dart';

/// [Widget] wrapper callback.
typedef WidgetWrapper = Widget Function(BuildContext context, Widget child);

/// A signature for the `AsyncBuilder` function.
typedef DataBuilder<T> = Widget Function(BuildContext context, T data);

/// A signature for the [Async.errorBuilder] function.
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

/// Async scope for flutter_async.
class Async extends StatelessWidget {
  /// Creates an [Async] widget.
  const Async({
    super.key,
    this.wrapper,
    required this.config,
    required this.child,
  });

  /// The config to be providen below this [Async].
  final AsyncConfig config;

  /// Utility [WidgetWrapper] for [Async.child].
  final WidgetWrapper? wrapper;

  /// The child of this [Async].
  final Widget child;

  /// Returns the [AsyncConfig] of the nearest [Async] or default.
  static AsyncConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_InheritedAsync>();
    return scope?.config ?? const AsyncConfig();
  }

  /// Returns [AsyncConfig.noneBuilder] or default.
  static Widget noneBuilder(BuildContext context) {
    final builder = of(context).noneBuilder;
    if (builder != null) return builder(context);

    // default
    return const Text('-');
  }

  /// Returns [AsyncConfig.errorBuilder] or default.
  static Widget errorBuilder(BuildContext context, Object e, StackTrace s) {
    final builder = of(context).errorBuilder;
    if (builder != null) return builder(context, e, s);

    // default
    var message = e.toString();
    try {
      // ignore: avoid_dynamic_calls
      message = (e as dynamic).message as String;
    } catch (_) {}

    return AdaptiveTheme(child: Text(message));
  }

  /// Returns [AsyncConfig.loadingBuilder] or default.
  static Widget loadingBuilder(BuildContext context) {
    final builder = of(context).loadingBuilder;
    if (builder != null) return builder(context);

    // default
    return const AsyncIndicator(alignment: null);
  }

  /// Returns [AsyncConfig.reloadingBuilder] or default.
  static Widget reloadingBuilder(BuildContext context) {
    final builder = Async.of(context).reloadingBuilder;
    if (builder != null) return builder(context);

    // default
    return AsyncIndicator.linear();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Widget child = _InheritedAsync(
          config: config,
          child: this.child,
        );

        if (wrapper != null) {
          child = wrapper!(context, child);
        }

        return child;
      },
    );
  }
}

class _InheritedAsync extends InheritedWidget {
  const _InheritedAsync({
    required this.config,
    required super.child,
  });

  /// The [AsyncConfig] of this [BuildContext].
  final AsyncConfig config;

  @override
  bool updateShouldNotify(_InheritedAsync oldWidget) => false;
}
