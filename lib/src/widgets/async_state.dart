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
  void setLoading(bool isLoading) {
    loading.value = isLoading;
    widget.controller?.loading.value = isLoading;
  }

  /// Sets the error state to [hasError].
  void setError(bool hasError, [Object? error, StackTrace? stackTrace]) {
    setState(() {
      _hasError = hasError;
      _error = error;
      _stackTrace = stackTrace;
    });
  }

  /// Sets the [AsyncState] to [isLoading] or [hasError] and calls [action].
  Future<void> setAction(FutureOr<void> action(),
      [Duration? errorDuration]) async {
    if (isLoading) return debugPrint('AsyncState is already loading.');
    try {
      setLoading(true);
      await action(); // * <-- The action is called here.
    } catch (e, s) {
      setError(true, e, s);
      final duration = errorDuration ?? this.errorDuration;
      if (duration != null) await Future.delayed(duration);
    } finally {
      setError(false);
      setLoading(false);
    }
  }

  void listener() {
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
    Listenable.merge(widget.listenables).addListener(listener);
    loading.addListener(() => setState(() {}));
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    print(widget.controller);
    if (widget.controller != oldWidget.controller) {
      widget.controller?.attach(this);
      print('REATTACH');
    }
    if (widget.listenables != oldWidget.listenables) {
      // print(widget.runtimeType);
      // print('new listenables');
      Listenable.merge(oldWidget.listenables).removeListener(listener);
      Listenable.merge(widget.listenables).addListener(listener);
      listener();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    listener();
    super.reassemble();
  }

  @override
  void dispose() {
    loading.dispose();
    Listenable.merge(widget.listenables).removeListener(listener);
    super.dispose();
  }
}
