// ignore_for_file: use_function_type_syntax_for_parameters

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async/src/async_controller_impl.dart';

import '../../flutter_async.dart';

abstract class AsyncWidget<T> extends StatefulWidget {
  const AsyncWidget({
    Key? key,
    this.controller,
    required this.listenables,
  }) : super(key: key);

  /// The [AsyncController] for this widget.
  final AsyncController<T>? controller;

  /// Listen to local or global listenables.
  final List<ValueListenable<bool>> listenables;
}

abstract class AsyncState<W extends AsyncWidget<T>, T> extends State<W>
    implements AsyncController<T> {
  var _hasError = false;
  Object? _error;
  StackTrace? _stackTrace;

  @override
  late final loading = ValueNotifier(false);

  @override
  bool get isLoading => loading.value;

  @override
  bool get hasError => _hasError;

  @override
  Object? get error => _error;

  @override
  StackTrace? get stackTrace => _stackTrace;

  /// The duration to show the error widget.
  ///
  /// When null, the feature is disabled.
  Duration? get errorDuration;

  /// Sets the loading state to [isLoading].
  @protected
  void setLoading(bool isLoading) {
    loading.value = isLoading;
    widget.controller?.loading.value = isLoading;
  }

  /// Sets the error state to [hasError].
  @protected
  void setError(bool hasError, [Object? error, StackTrace? stackTrace]) {
    setState(() {
      _hasError = hasError;
      _error = error;
      _stackTrace = stackTrace;
    });
  }

  /// Sets the [AsyncState] to [isLoading] or [hasError] and calls [action].
  @protected
  Future<void> setAction(FutureOr<void> action(),
      [Duration? errorDuration]) async {

    AsyncObserver.init?.call(this);

    if (isLoading) {
      AsyncObserver.insist?.call(this);
      return debugPrint('AsyncState is already loading.');
    }

    AsyncObserver.start?.call(this);

    try {
      setLoading(true);
      await action(); // * <-- The action is called here.

      AsyncObserver.success?.call(this);

    } catch (e, s) {
      setError(true, e, s);

      AsyncObserver.error?.call(this);
      
      final duration = errorDuration ?? this.errorDuration;
      if (duration != null) await Future.delayed(duration);
    } finally {
      setError(false);
      setLoading(false);
    }
  }

  void _listener() {
    if (widget.listenables.isEmpty) return;
    setLoading(widget.listenables.any((l) => l.value));
  }

  @override
  void initState() {
    widget.controller?.attach(this);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    Listenable.merge(widget.listenables).addListener(_listener);
    loading.addListener(() => setState(() {}));
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    if (widget.controller != oldWidget.controller) {
      widget.controller?.attach(this);
    }
    if (widget.listenables != oldWidget.listenables) {
      Listenable.merge(oldWidget.listenables).removeListener(_listener);
      Listenable.merge(widget.listenables).addListener(_listener);
      _listener();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    _listener();
    super.reassemble();
  }

  @override
  void dispose() {
    loading.dispose();
    Listenable.merge(widget.listenables).removeListener(_listener);
    super.dispose();
  }
}
