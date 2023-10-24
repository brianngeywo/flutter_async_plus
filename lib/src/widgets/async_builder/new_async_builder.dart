import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

import '../../../flutter_async.dart';

class AsyncReloader extends StatelessWidget {
  const AsyncReloader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// A [Widget] that listens to [Future] and [Stream] events.
class NewAsyncBuilder<T> extends StatefulWidget {
  /// Creates an [AsyncBuilder] with [future] or [stream].
  const NewAsyncBuilder({
    super.key,
    this.initialData,
    this.future,
    this.stream,
    this.noneBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.reloadingBuilder = reloadingBuilderOf,
    required this.builder,
  }) : assert(future == null || stream == null, 'cannot set future and stream');

  static Widget reloadingBuilderOf(BuildContext context, data) {
    return Async.inheritedReloader(context);
  }

  /// The initial [T] data to pass to [builder].
  final T? initialData;

  /// The [Future] to listen to.
  final Future<T>? future;

  /// The [Stream] to listen to.
  final Stream<T>? stream;

  /// A wrapper o
  final Widget Function(BuildContext context, Widget child) onWidget;

  /// The [WidgetBuilder] to show while error and data are null.
  final WidgetBuilder? noneBuilder;

  /// The [ErrorBuilder] to show on errors.
  final ErrorBuilder? errorBuilder;

  /// The [WidgetBuilder] to show while loading.
  final WidgetBuilder? loadingBuilder;

  /// The [WidgetBuilder] to show while loading.
  final DataBuilder<T>? reloadingBuilder;

  /// The [DataBuilder] to show on data.
  final DataBuilder<T> builder;

  @override
  State<NewAsyncBuilder<T>> createState() => _NewAsyncBuilderState();
}

class _NewAsyncBuilderState<T> extends State<NewAsyncBuilder<T>> {
  late final _async = AsyncNotifier.late<T>(value: widget.initialData);

  @override
  void initState() {
    super.initState();
    if (widget.future != null) _async.future = widget.future;
    if (widget.stream != null) _async.stream = widget.stream;
    _async.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant NewAsyncBuilder<T> oldWidget) {
    if (widget.future != oldWidget.future && widget.future != null) {
      _async.future = widget.future;
    }
    if (widget.stream != oldWidget.stream && widget.stream != null) {
      _async.stream = widget.stream;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _async.dispose();
    super.dispose();
  }

  Widget idle() => widget.noneBuilder!(context);

  Widget data(T data) => widget.builder(context, data);

  Widget error(Object error, StackTrace stackTrace) {
    if (_async.value is T) {
      return const Align(
        alignment: Alignment.topCenter,
        child: LinearProgressIndicator(
          value: 1,
          valueColor: AlwaysStoppedAnimation(Colors.redAccent),
        ),
      );
    }
    return Text(error.toString());
  }

  Widget loading() => const CircularProgressIndicator();

  Widget reloading(T data) {
    return Align(
      alignment: Alignment.topCenter,
      child: LinearProgressIndicator(
        color: _async.hasError ? Colors.red : null,
        backgroundColor: _async.hasError ? Colors.red[100] : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_async.hasError && !_async.isReloading)
          error(_async.error!, _async.stackTrace ?? StackTrace.current),
        if (_async.isLoading && !_async.isReloading) loading(),
        if (_async.isReloading) reloading(_async.requireData),
        if (_async.value is T) data(_async.requireData),
        // if (_notifier.isIdle) idle(),
      ],
    );
  }
}
