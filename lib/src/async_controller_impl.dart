// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter_async.dart';
import 'widgets/async_builder/async_state.dart';
import 'widgets/async_state.dart';

@protected
class AsyncControllerImpl<T> implements AsyncController<T> {
  final state = <AsyncState<AsyncWidget<T>, T>>{};

  Set<AsyncState<AsyncWidget<T>, T>> get _state {
    assert(state.isNotEmpty, 'AsyncController not attached to any AsyncWidget');
    return state;
  }

  @override
  final loading = ValueNotifier(false);

  @override
  bool get isLoading => _state.any((state) => state.isLoading);

  @override
  bool get hasError => _state.any((state) => state.hasError);

  @override
  Object? get error =>
      hasError ? state.firstWhere((e) => e.hasError).error : null;

  @override
  StackTrace? get stackTrace =>
      hasError ? state.firstWhere((e) => e.hasError).stackTrace : null;

  @override
  FutureOr<void> reload() => Future.wait(_state.map((e) async => e.reload()));
}

@protected
class AsyncButtonControllerImpl<T> extends AsyncControllerImpl<T>
    implements AsyncButtonController<T> {
  Set<AsyncButtonState> get button {
    final l = state.whereType<AsyncButtonState>();
    assert(l.isNotEmpty, 'AsyncController not attached to any AsyncButton');
    return l.toSet();
  }

  @override
  FutureOr<void> press() => Future.wait(button.map((e) async => e.press()));
  @override
  FutureOr<void> longPress() =>
      Future.wait(button.map((e) async => e.longPress()));
  @override
  bool get isElevatedButton => button.any((e) => e.isElevatedButton);
  @override
  bool get isTextButton => button.any((e) => e.isTextButton);
  @override
  bool get isOutlinedButton => button.any((e) => e.isOutlinedButton);
  @override
  bool get isFilledButton => button.any((e) => e.isFilledButton);
  @override
  Size get size => button.first.size;
}

@protected
class AsyncBuilderControllerImpl<T> extends AsyncControllerImpl<T>
    implements AsyncStreamController<T>, AsyncFutureController<T> {
  Set<AsyncBuilderState<Object?>> get builder {
    final l = state.whereType<AsyncBuilderState>();
    assert(l.isNotEmpty, 'AsyncController not attached to any AsyncBuilder');
    return l.toSet();
  }

  @override
  bool get isPaused => builder.any((e) => e.isPaused);

  @override
  bool get isReloading => builder.any((e) => e.isReloading);

  @override
  bool get hasData => builder.any((e) => e.hasData);

  @override
  T? get data {
    if (!hasData) return null;
    return builder.firstWhere((e) => e.hasData).data as T?;
  }

  @override
  void pause([Future<void>? resumeSignal]) =>
      builder.forEach((e) => e.pause(resumeSignal));

  @override
  void resume() => builder.forEach((e) => e.resume());

  @override
  FutureOr<void> cancel() => Future.wait(builder.map((e) async => e.cancel()));
}

extension AsyncControllerExtension<T> on AsyncController<T> {
  /// All [AsyncState] attached.
  Set<AsyncState<AsyncWidget<T>, T>> get _state =>
      (this as AsyncControllerImpl<T>).state;

  /// Attach the [state] to the controller.
  void attach(AsyncState<AsyncWidget<T>, T> state) {
    _state.add(state);
  }
}
