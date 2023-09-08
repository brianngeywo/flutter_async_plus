import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_async/flutter_async.dart';
import 'package:flutter_async/src/widgets/animated_style_mixin.dart';
import 'package:flutter_async/src/widgets/async_state.dart';

typedef AsyncStateCallback = void Function(AsyncState state);

/// Every [AsyncWidget] in this package extends [AsyncState].
///
/// So you can consistently observe the state of any [AsyncWidget] in your app.
class AsyncObserver {
  static AsyncStateCallback? init;
  static AsyncStateCallback? start;
  static AsyncStateCallback? insist;
  static AsyncStateCallback? success;
  static AsyncStateCallback? error;
  static AsyncStateCallback? loading;

  /// Called when an [AsyncWidget] action inits.
  static void onActionInit(AsyncStateCallback fn) => init = fn;

  /// Called when an [AsyncWidget] starts computing/loading.
  static void onActionStart(AsyncStateCallback fn) => start = fn;

  /// Called when an [AsyncWidget] is called but already started.
  static void onActionInsist(AsyncStateCallback fn) => insist = fn;

  /// Called when an [AsyncWidget] action finishes with success.
  static void onActionSuccess(AsyncStateCallback fn) => success = fn;

  /// Called when an [AsyncWidget] action finishes with error.
  static void onActionError(AsyncStateCallback fn) => error = fn;
}

typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

/// Utility widget that handles void async taks, lifecycle and inherited builders.
class Async extends StatefulWidget {
  const Async({
    super.key,
    // Lifecycle.
    this.init,
    this.dispose,
    this.reassemble,
    this.keepAlive = false,
    this.style,

    // Widget.
    this.error,
    this.loader,
    this.reloader,
    this.config,
    required this.child,
  });

  /// Smart init. Adds a [loader] while awaiting for [init]
  ///
  /// Use void Function() to disable and Future<void> to enable.
  ///
  /// Ex: init:
  /// - () async => Future.delayed(1.second); <- enabled
  /// - () => Future.delayed(1.second); <- disabled
  final VoidCallback? init;

  /// Widget State.dispose callback.
  final VoidCallback? dispose;

  /// Widget State.reassemble callback.
  final VoidCallback? reassemble;

  /// Makes this child alive.
  final bool keepAlive;

  /// The widget to show on errors.
  final ErrorBuilder? error;

  /// The widget to show while loading.
  final WidgetBuilder? loader;

  /// The widget when [AsyncBuilder] has completed at least once.
  final WidgetBuilder? reloader;

  /// Style inheritance. TEST.
  final AsyncConfig? config;

  final AsyncStyle? style;
  final Widget child;

  /// Returns the [AsyncState] of the nearest [Async] ancestor or null.
  static AsyncState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AsyncState>();
  }

  /// Returns the [AsyncState] of the nearest [Async] ancestor or throw.
  static AsyncState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, '[Async] widget not found');
    return state!;
  }

  static Widget inheritedError(BuildContext context, Object e, StackTrace? s) {
    return Async.maybeOf(context)?.scope?.error?.call(context, e, s) ??
        Text(e.toString());
  }

  static Widget inheritedLoader(BuildContext context) {
    return Async.maybeOf(context)?.scope?.loader?.call(context) ??
        const CircularProgressIndicator();
  }

  static Widget inheritedReloader(BuildContext context) {
    return Async.maybeOf(context)?.scope?.reloader?.call(context) ??
        const Align(
          alignment: Alignment.topCenter,
          child: LinearProgressIndicator(),
        );
  }

  @override
  State<Async> createState() => _AsyncState();
}

extension AsyncStateExtension on AsyncState {
  AsyncConfig get config {
    return scope?.config ?? const AsyncConfig();
  }
}

extension on State {
  _InheritedAsync? get scope {
    return context.dependOnInheritedWidgetOfExactType<_InheritedAsync>();
  }
}

class _AsyncState extends State<Async> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAlive;

  // Smart init.
  FutureOr<void> Function()? get init => widget.init;
  var isReady = false;

  void smartInit() async {
    await init?.call();
    isReady = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    smartInit();
  }

  @override
  void dispose() {
    widget.dispose?.call();
    super.dispose();
  }

  @override
  void reassemble() {
    widget.reassemble?.call();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final scope = context.dependOnInheritedWidgetOfExactType<_InheritedAsync>();

    if (!isReady) {
      return widget.loader?.call(context) ??
          scope?.loader?.call(context) ??
          const SizedBox.shrink();
    }

    return _InheritedAsync(
      config: widget.config ?? scope?.config,
      error: widget.error ?? scope?.error,
      loader: widget.loader ?? scope?.loader,
      reloader: widget.reloader ?? scope?.reloader,
      child: widget.child,
    );
  }
}

class _InheritedAsync extends InheritedWidget {
  const _InheritedAsync({
    // required this.theme,
    // required this.style,
    required this.config,
    required this.error,
    required this.loader,
    required this.reloader,
    required super.child,
  });

  /// The default widget to show on errors.
  final ErrorBuilder? error;

  /// The default widget to show while loading.
  final WidgetBuilder? loader;

  /// The default widget when [AsyncBuilder] has completed at least once.
  final WidgetBuilder? reloader;

  /// The config that all [AsyncWidget] will inherit.
  final AsyncConfig? config;

  @override
  bool updateShouldNotify(_InheritedAsync oldWidget) => false;
}
