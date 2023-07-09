// ignore_for_file: use_function_type_syntax_for_parameters

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../flutter_async.dart';
import '../async_controller_impl.dart';

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

abstract class _AsyncState<W extends AsyncWidget> extends State<W>
    implements
        AsyncButtonController,
        AsyncStreamController,
        AsyncFutureController,
        AsyncController {
  // * AsyncController
  @override
  void attach(state) => throw UnimplementedError();
  @override
  bool get isAttached => throw UnimplementedError();

  // * AsyncFutureController
  @override
  get data => throw UnimplementedError();
  @override
  bool get hasData => throw UnimplementedError();
  @override
  bool get isReloading => throw UnimplementedError();
  @override
  bool get isPaused => throw UnimplementedError();

  // * AsyncStreamController & AsyncFutureController
  @override
  void pause([resumeSignal]) => throw UnimplementedError();
  @override
  void resume() => throw UnimplementedError();
  @override
  FutureOr<void> cancel() => throw UnimplementedError();

  // * AsyncButtonController
  @override
  bool get isElevatedButton => widget is AsyncButton<ElevatedButton>;
  @override
  bool get isTextButton => widget is AsyncButton<TextButton>;
  @override
  bool get isOutlinedButton => widget is AsyncButton<OutlinedButton>;
  @override
  bool get isFilledButton => widget is AsyncButton<FilledButton>;
  @override
  FutureOr<void> longPress() => throw UnimplementedError();
  @override
  FutureOr<void> press() => throw UnimplementedError();
}

abstract class AsyncState<W extends AsyncWidget<T>, T> extends _AsyncState<W> {
  var _hasError = false;
  Object? _error;
  StackTrace? _stackTrace;
  Size? _size;

  bool get hasSize => _size != null;

  @override
  Size get size => _size!;

  @override
  ValueNotifier<bool> get loading => controller.loading;

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

  /// The [Exception.message], [Error.message] or [Object.toString].
  String get errorMessage {
    try {
      return (error as dynamic).message;
    } catch (_) {
      return '$error';
    }
  }

  /// Sets the loading state to [isLoading].
  void setLoading(bool isLoading) {
    loading.value = isLoading;
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

  late final controller = widget.controller ?? AsyncControllerImpl();

  WidgetsBinding? get _binding => WidgetsBinding.instance;

  @override
  void initState() {
    controller.attach(this);
    _binding?.addPostFrameCallback((_) => _size ??= context.size);
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
