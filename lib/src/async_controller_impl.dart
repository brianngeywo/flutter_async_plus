// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter_async.dart';
import 'widgets/async_builder/async_state.dart';
import 'widgets/async_state.dart';

@protected
class AsyncControllerImpl<T> implements AsyncController<T> {
  final state = <AsyncState>{};

  Set<AsyncState> get _state {
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

  @override
  bool operator ==(Object other) {
    print('identical: ');
    // TODO: Verify didUpdateWidget, if is called when the controller changes.
    if (identical(this, other)) return true;

    return other is AsyncControllerImpl<T> && other.hashCode == state.hashCode;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ state.hashCode;
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

  @override
  bool operator ==(Object other) {
    print('identical: ');
    if (identical(this, other)) return true;

    return other is AsyncControllerImpl<T> && other.state == state;
  }
}

@protected
class AsyncBuilderControllerImpl<T> extends AsyncControllerImpl<T>
    implements AsyncStreamController<T>, AsyncFutureController<T> {
  Set<AsyncBuilderState> get builder {
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
    return builder.firstWhere((e) => e.hasData).data;
  }

  @override
  void pause([resumeSignal]) => builder.forEach((e) => e.pause(resumeSignal));

  @override
  void resume() => builder.forEach((e) => e.resume());

  @override
  FutureOr<void> cancel() => Future.wait(builder.map((e) async => e.cancel()));
}

extension AsyncControllerExtensijhoon on AsyncController {
  void attach(AsyncState state) {
    (this as dynamic).state.add(state);
  }
}
