import 'dart:async';

import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

import '../../extensions/context.dart';
import '../../utils/async_state.dart';
import '../async/async.dart';

/// A [Widget] that listens to [Future] and [Stream] events.
@immutable
class AsyncBuilder<T> extends StatefulWidget {
  /// Creates an [AsyncBuilder] with [future] or [stream].
  const AsyncBuilder({
    super.key,
    this.initialData,
    this.future,
    this.stream,
    this.wrapper,
    this.alignment = Alignment.center,
    this.noneBuilder = _noneBuilder,
    this.errorBuilder = _errorBuilder,
    this.loadingBuilder = _loadingBuilder,
    this.reloadingBuilder = _reloadingBuilder,
    this.skipReloading = false,
    required this.builder,
  })  : assert(
          future == null || stream == null,
          'Cannot set both future and stream',
        ),
        streamFn = null,
        futureFn = null,
        interval = null;

  /// Creates an [AsyncBuilder] with [future] or [stream] as functions.
  ///
  /// This constructor is useful when you want to reload [future] and [stream]
  /// callbacks. Add [interval] to reload them periodically.
  const AsyncBuilder.function({
    super.key,
    this.initialData,
    this.interval,
    Future<T> Function()? future,
    Stream<T> Function()? stream,
    this.wrapper,
    this.alignment = Alignment.center,
    this.noneBuilder = _noneBuilder,
    this.errorBuilder = _errorBuilder,
    this.loadingBuilder = _loadingBuilder,
    this.reloadingBuilder = _reloadingBuilder,
    this.skipReloading = false,
    required this.builder,
  })  : assert(
          future == null || stream == null,
          'cannot set both future and stream',
        ),
        futureFn = future,
        streamFn = stream,
        future = null,
        stream = null;

  static Widget _reloadingBuilder(BuildContext context) {
    final builder = Async.of(context).builderConfig?.reloadingBuilder;
    if (builder != null) return builder(context);

    return Async.reloadingBuilder(context);
  }

  static Widget _noneBuilder(BuildContext context) {
    final builder = Async.of(context).builderConfig?.noneBuilder;
    if (builder != null) return builder(context);

    return Async.noneBuilder(context);
  }

  static Widget _loadingBuilder(BuildContext context) {
    final builder = Async.of(context).builderConfig?.loadingBuilder;
    if (builder != null) return builder(context);

    return Async.loadingBuilder(context);
  }

  static Widget _errorBuilder(BuildContext context, Object e, StackTrace s) {
    final builder = Async.of(context).builderConfig?.errorBuilder;
    if (builder != null) return builder(context, e, s);

    return Async.errorBuilder(context, e, s);
  }

  /// The initial [T] data to pass to [builder].
  final T? initialData;

  /// The [Future] to listen.
  final Future<T>? future;

  /// The [Future] function to load and listen.
  final Future<T> Function()? futureFn;

  /// The [Stream] to listen.
  final Stream<T>? stream;

  /// The [Stream] function to load and listen.
  final Stream<T> Function()? streamFn;

  /// The interval to reload `future/stream` callbacks.
  final Duration? interval;

  /// How builders should be aligned.
  final AlignmentGeometry? alignment;

  /// An utility wrapper around all builders.
  final WidgetWrapper? wrapper;

  /// Whether to skip reloading state.
  final bool skipReloading;

  /// The [WidgetWrapper] to wrap on [builder] or [errorBuilder] while reloading.
  final WidgetBuilder reloadingBuilder;

  /// The [WidgetBuilder] to show while error and data are null.
  final WidgetBuilder noneBuilder;

  /// The [ErrorBuilder] to show on errors.
  final ErrorBuilder errorBuilder;

  /// The [WidgetBuilder] to show while loading.
  final WidgetBuilder loadingBuilder;

  /// The [DataBuilder] to show on data.
  final DataBuilder<T> builder;

  /// Returns the first [AsyncBuilderState] above this [context].
  static AsyncBuilderState<T> of<T>(BuildContext context) {
    final state = context.findAncestorStateOfType<AsyncBuilderState<T>>();
    assert(state != null, 'No AsyncBuilder of this context');
    return state!;
  }

  /// Returns the first [AsyncBuilderState] below this [context].
  /// Filters by [key], if given.
  static AsyncBuilderState<T> at<T>(BuildContext context, {Key? key}) {
    return context.visitState(
      assertType: 'AsyncBuilder',
      filter: (state) => key == null || state.widget.key == key,
    );
  }

  @override
  State<AsyncBuilder<T>> createState() => AsyncBuilderState();
}

/// The [State] of [AsyncBuilder].
class AsyncBuilderState<T> extends AsyncState<AsyncBuilder<T>, T> {
  Timer? _timer;

  @override
  T? get initialData => widget.initialData;

  @override
  void initState() {
    // `AsyncBuilder`
    if (widget.future != null) async.future = widget.future;
    if (widget.stream != null) async.stream = widget.stream;

    // `AsyncBuilder.function`
    if (widget.futureFn != null || widget.streamFn != null) {
      reload();
      _setInterval(widget.interval);
    }

    super.initState();
  }

  /// Reloads `future` or `stream` function of an [AsyncBuilder.function].
  void reload() {
    assert(
      widget.futureFn != null || widget.streamFn != null,
      'Tried to reload an `AsyncBuilder` without functions. In order to use '
      '`reload()`, you must use `AsyncBuilder.function` constructor.',
    );
    if (widget.futureFn != null) async.future = widget.futureFn!();
    if (widget.streamFn != null) async.stream = widget.streamFn!();
  }

  void _setInterval(Duration? interval) {
    _timer?.cancel();
    if (interval != null) {
      _timer = Timer.periodic(interval, (_) => reload());
    }
  }

  @override
  void didUpdateWidget(covariant AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.future != oldWidget.future && widget.future != null) {
      async.future = widget.future;
    }
    if (widget.stream != oldWidget.stream && widget.stream != null) {
      async.stream = widget.stream;
    }
    if (widget.interval != oldWidget.interval) _setInterval(widget.interval);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var child = async.when(
          skipLoading: !widget.skipReloading,
          none: () => widget.noneBuilder(context),
          error: (e, s) => widget.errorBuilder(context, e, s),
          loading: () => widget.loadingBuilder(context),
          data: (data) => widget.builder(context, data),
        );

        if (widget.alignment != null) {
          child = Align(alignment: widget.alignment!, child: child);
        }

        if (!widget.skipReloading) {
          child = Stack(
            children: [
              child,
              if (async.isReloading) widget.reloadingBuilder(context),
            ],
          );
        }

        if (widget.wrapper != null) {
          child = widget.wrapper!(context, child);
        }

        return child;
      },
    );
  }
}
