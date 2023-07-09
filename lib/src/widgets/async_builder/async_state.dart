import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

import '../async_state.dart';
import 'async_builder.dart';

class AsyncBuilderState<T> extends AsyncState<AsyncBuilder<T>, T> {
  @override
  void pause([resumeSignal]) {
    setState(() => _subscription?.pause(resumeSignal));
  }

  @override
  void resume() {
    setState(() => _subscription?.resume());
  }

  @override
  Future<void> cancel() async {
    await _subscription?.cancel().then((_) => setState(() {}));
  }

  @override
  void reload() {
    _retry = 0;
    _initAsync();
  }

  T? _data;
  Timer? timer;
  Object? _error;
  StackTrace? _stackTrace;
  StreamSubscription? _subscription;
  var _retry = 0;
  var _isDataSet = false;

  T? get rawData => _data;

  @override
  Object? get error => _error;

  @override
  StackTrace? get stackTrace => _stackTrace;

  void _setData(T? data) {
    setState(() {
      _isDataSet = true;
      _data = data;
    });
  }

  void _setInterval(Duration? interval) {
    _retry = 0;
    timer?.cancel();

    if (interval == null) return;
    timer = Timer.periodic(interval, (_) => _initAsync());
  }

  void _onError(Object error, StackTrace stackTrace) {
    if (_retry < widget.retry) {
      _retry++;
      Future.microtask(_initAsync);
    } else if (widget.error != null) {
      setState(() {
        _error = error;
        _stackTrace = stackTrace;
      });
    }

    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'AsyncBuilder',
      context: ErrorDescription('while building AsyncBuilder<$T>'),
    ));
  }

  void _initAsync() {
    _error = _stackTrace = null;

    if (widget.future != null) _initFuture();
    if (widget.stream != null) _initStream();
  }

  void _initFuture() {
    loading.value = true;

    widget.future!()
        .then(_setData, onError: _onError)
        .whenComplete(() => loading.value = false);
  }

  void _initStream() {
    loading.value = true;

    _subscription?.cancel();
    _subscription = widget.stream!().listen(
      _setData,
      onDone: () => loading.value = false,
      onError: _onError,
    );
  }

  @override
  void initState() {
    super.initState();
    controller.attach(this);

    if (widget.initialData != null) _setData(widget.initialData);
    if (widget.interval != null) _setInterval(widget.interval);

    _initAsync();
  }

  @override
  void didUpdateWidget(AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialData != oldWidget.initialData) {
      _setData(widget.initialData);
    }
    if (widget.interval != oldWidget.interval) _setInterval(widget.interval);
  }

  @override
  void dispose() {
    timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  T? get data => _data;

  T get dataOrThrow {
    try {
      return _data as T;
    } catch (e, s) {
      _error = e;
      _stackTrace = s;
      throw FlutterError('AsyncBuilder: No data, if loader and reloader are '
          'null, you must provide an initial value or make your data nullable.');
    }
  }

  @override
  Duration? get errorDuration => null; //todo refactor
  @override
  bool get isLoading => loading.value && !isPaused && !_isDataSet;
  @override
  bool get isReloading => loading.value && !isPaused && _isDataSet;
  @override
  bool get isPaused => _subscription?.isPaused ?? false;
  @override
  bool get hasError => _error != null && !isLoading;
  @override
  bool get hasData => _data != null;

  @override
  Widget build(BuildContext context) {
    /// Stack inherits the size of the largest child.
    return Stack(
      alignment: Alignment.center,
      children: [
        // On data.
        if (_isDataSet && !hasError) widget.builder(dataOrThrow),

        // On loading.
        if (widget.loader != null)
          KeepSize(visible: isLoading, child: widget.loader!),

        // On reloading.
        if (widget.reloader != null)
          KeepSize(visible: isReloading, child: widget.reloader!),

        // On error.
        if (widget.error != null)
          KeepSize(visible: hasError, child: widget.error!(controller)),
      ],
    );
  }
}

class KeepSize extends Visibility {
  const KeepSize({
    Key? key,
    bool visible = false,
    required Widget child,
  }) : super(
          key: key,
          visible: visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          maintainInteractivity: false,
          maintainSemantics: false,
          child: child,
        );
}
