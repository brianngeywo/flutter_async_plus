// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async/src/widgets/async_state.dart';

import '../../async_controller.dart';
import '../async/inherited_async.dart';
import 'async_state.dart';

/// A widget that builds depending on the state of a [Future] or [Stream].
class AsyncBuilder<T> extends StatefulWidget implements AsyncWidget<T> {
  /// Creates a widget that builds depending on the state of a [Future] or [Stream].
  const AsyncBuilder({
    super.key,
    this.controller,
    this.listenables = const [],
    this.initialData,
    this.getFuture,
    this.getStream,
    this.interval,
    this.retry = 0,
    this.error = Async.inheritedError,
    this.loader = Async.inheritedLoader,
    this.reloader = Async.inheritedReloader,
    required this.builder,
  }) : assert(getFuture == null || getStream == null,
            'Cannot provide both a getFuture and a getStream');

  @override
  final List<ValueListenable<bool>> listenables;
  @override
  final AsyncController<T>? controller;

  /// The initial data to pass to the [builder].
  final T? initialData;

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
