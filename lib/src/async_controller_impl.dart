import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter_async.dart';
import 'widgets/async_state.dart';

@protected
class AsyncControllerImpl<T> implements AsyncController<T> {
  AsyncState? _state;
  AsyncState get state {
    assert(isAttached, 'AsyncController is not attached to an async widget.');
    return _state!;
  }

  @override
  void attach(state) => _state = state;

  @override
  bool get isAttached => _state != null;

  @override
  final loading = ValueNotifier(false);

  @override
  bool get isLoading => state.isLoading;

  @override
  bool get hasError => state.hasError;

  @override
  Object? get error => state.error;

  @override
  StackTrace? get stackTrace => state.stackTrace;

  @override
  void reload() => state.reload();
}

@protected
class AsyncButtonControllerImpl<T> extends AsyncControllerImpl<T>
    implements AsyncButtonController<T> {
  @override
  FutureOr<void> press() => state.press();
  @override
  FutureOr<void> longPress() => state.longPress();
  @override
  bool get isElevatedButton => state.isElevatedButton;
  @override
  bool get isTextButton => state.isTextButton;
  @override
  bool get isOutlinedButton => state.isOutlinedButton;
  @override
  bool get isFilledButton => state.isFilledButton;
  @override
  Size get size => state.size;
}

@protected
class AsyncBuilderControllerImpl<T> extends AsyncControllerImpl<T>
    implements AsyncStreamController<T>, AsyncFutureController<T> {
  @override
  bool get isPaused => state.isPaused;

  @override
  bool get isReloading => state.isReloading;

  @override
  bool get hasData => state.hasData;

  @override
  T? get data => state.data;

  @override
  void pause([resumeSignal]) => state.pause(resumeSignal);

  @override
  void resume() => state.resume();

  @override
  FutureOr<void> cancel() => state.cancel();
}
