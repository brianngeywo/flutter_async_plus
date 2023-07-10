// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async/src/widgets/async_state.dart';

import '../../async_controller.dart';
import 'async_state.dart';

/// A widget that builds depending on the state of a [Future] or [Stream].
class AsyncBuilder<T> extends StatefulWidget implements AsyncWidget<T> {
  /// Creates a widget that builds depending on the state of a [Future] or [Stream].
  const AsyncBuilder({
    Key? key,
    this.controller,
    this.listenables = const [],
    this.initialData,
    this.future,
    this.stream,
    this.interval,
    this.retry = 0,
    this.error = defaultError,
    this.loader = const CircularProgressIndicator(),
    this.reloader = const Align(
      alignment: Alignment.topCenter,
      child: LinearProgressIndicator(),
    ),
    required this.builder,
  })  : assert(future == null || stream == null,
            'Must set a future or stream, not both'),
        super(key: key);

  static Widget defaultError(AsyncController controller) {
    return Text(controller.errorMessage);
  }

  const AsyncBuilder.min({
    Key? key,
    this.controller,
    this.listenables = const [],
    this.initialData,
    this.future,
    this.stream,
    this.interval,
    this.retry = 0,
    this.error,
    this.loader,
    this.reloader,
    required this.builder,
  })  : assert(future == null || stream == null,
            'Must provide a future or stream, not both'),
        super(key: key);

  /// Full control over the [AsyncBuilder] with [BuildContext].
  factory AsyncBuilder.full({
    Key? key,
    AsyncController<T>? controller,
    List<ValueListenable<bool>> listenables = const [],
    T? initial,
    Future<T> future()?,
    Stream<T> stream()?,
    Duration? interval,
    int retry = 0,
    WidgetBuilder? loader,
    WidgetBuilder? reloader,
    Widget error(BuildContext context, AsyncController controller)?,
    required Widget builder(BuildContext context, T data),
  }) {
    return AsyncBuilder(
      key: key,
      controller: controller,
      listenables: listenables,
      initialData: initial,
      future: future,
      stream: stream,
      interval: interval,
      retry: retry,
      error: error != null ? (c) => Builder(builder: (_) => error(_, c)) : null,
      loader: loader != null ? Builder(builder: loader) : null,
      reloader: reloader != null ? Builder(builder: reloader) : null,
      builder: (data) => Builder(builder: (_) => builder(_, data)),
    );
  }

  @override
  final List<ValueListenable<bool>> listenables;
  @override
  final AsyncController<T>? controller;

  /// The initial data to pass to the [builder].
  final T? initialData;

  /// The [Future] to load [builder] with. When set, [stream] must be null.
  final Future<T> Function()? future;

  /// The [Stream] to load [builder] with. When set, [future] must be null.
  final Stream<T> Function()? stream;

  /// The interval to reload the [future]/[stream].
  final Duration? interval;

  /// The number of times to retry the [future]/[stream] on error.
  final int retry;

  /// The widget to build when [future]/[stream].onError is called.
  final Widget Function(AsyncController controller)? error;

  /// The widget when [future]/[stream] has not completed the first time.
  final Widget? loader;

  /// The widget when [future]/[stream] has completed at least once.
  final Widget? reloader;

  /// The widget when [future]/[stream] has [T] data.
  final Widget Function(T data) builder;

  @override
  State<StatefulWidget> createState() => AsyncBuilderState<T>();
}
