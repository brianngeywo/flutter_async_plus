// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:flutter_async/src/widgets/async_state.dart';

import '../async/inherited_async.dart';
import 'async_state.dart';

/// A widget that builds depending on the state of a [Future] or [Stream].
class AsyncBuilder<T> extends AsyncWidget<T> {
  /// Creates a widget that builds depending on the state of a [Future] or [Stream].
  const AsyncBuilder({
    super.key,
    super.listenables = const [],
    this.init,
    this.dispose,
    this.initialData,
    this.future,
    this.stream,
    this.error = Async.inheritedError,
    this.loader = Async.inheritedLoader,
    this.reloader = Async.inheritedReloader,
    required this.builder,
  })  : getFuture = null,
        getStream = null,
        interval = null,
        retry = 0,
        assert(future == null || stream == null,
            'Cannot provide both a future and a stream'),
        super(controller: null);

  const AsyncBuilder.function({
    super.key,
    super.controller,
    super.listenables = const [],
    this.init,
    this.dispose,
    this.initialData,
    this.getFuture,
    this.getStream,
    this.interval,
    this.retry = 0,
    this.error = Async.inheritedError,
    this.loader = Async.inheritedLoader,
    this.reloader = Async.inheritedReloader,
    required this.builder,
  })  : future = null,
        stream = null,
        assert(getFuture == null || getStream == null,
            'Cannot provide both a getFuture and a getStream');

  /// [AsyncState.initState] callback.
  final VoidCallback? init;

  /// [AsyncState.dispose] callback.
  final VoidCallback? dispose;

  /// The initial data to pass to the [builder].
  final T? initialData;

  /// The [Future] to load [builder] with. When set, [stream] must be null.
  final Future<T>? future;

  /// The [Stream] to load [builder] with. When set, [future] must be null.
  final Stream<T>? stream;

  /// The [Future] to load [builder] with. When set, [getStream] must be null.
  final Future<T> Function()? getFuture;

  /// The [Stream] to load [builder] with. When set, [getFuture] must be null.
  final Stream<T> Function()? getStream;

  /// The interval to reload the [getFuture]/[getStream].
  final Duration? interval;

  /// The number of times to retry the [getFuture]/[getStream] on error.
  final int retry;

  /// The widget to build when [getFuture]/[getStream].onError is called.
  final ErrorBuilder? error;

  /// The widget when [getFuture]/[getStream] has not completed the first time.
  final WidgetBuilder? loader;

  /// The widget when [getFuture]/[getStream] has completed at least once.
  final WidgetBuilder? reloader;

  /// The widget when [getFuture]/[getStream] has [T] data.
  final Widget Function(BuildContext context, T data) builder;

  /// Returns the [AsyncBuilderState] of the nearest [AsyncBuilder] ancestor or null.
  static AsyncBuilderState? maybeOf(BuildContext context) {
    return context.findRootAncestorStateOfType<AsyncBuilderState>();
  }

  /// Returns the [AsyncBuilderState] of the nearest [AsyncBuilder] ancestor or throw.
  static AsyncBuilderState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'AsyncBuilder not found');
    return state!;
  }

  @override
  State<StatefulWidget> createState() => AsyncBuilderState<T>();
}
