import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_async/src/listenables/async_notifier.dart';

abstract class AsyncListenable<T> extends ValueListenable<T> {
  const AsyncListenable();

  /// The current [Stream]. If absent, returns [value] as [Stream.value].
  Stream<T> get stream;

  /// The current [Future]. If absent, returns [value] as [Future.value].
  Future<T> get future;

  /// The current [AsyncSnapshot] of [future] or [stream].
  AsyncSnapshot<T> get snapshot;
}

extension AsyncListenableExtension<T> on AsyncListenable<T> {
  /// Wheter [future] or [stream] is computing for the first time.
  bool get isLoading => snapshot.connectionState == ConnectionState.waiting;

  /// Wheter [future] or [stream] is recomputing.
  bool get isReloading =>
      (hasData || hasError) &&
      (isLoading || snapshot.connectionState == ConnectionState.active);

  /// Wheter [future] or [stream] threw an error.
  bool get hasError => snapshot.hasError;

  /// Wheter [future] or [stream] has data.
  bool get hasData => snapshot.hasData;

  /// The current error of [future] or [stream].
  Object? get error => snapshot.error;

  /// The current [StackTrace] of [future] or [stream].
  StackTrace? get stackTrace => snapshot.stackTrace;

  /// The current [ConnectionState] of [future] or [stream].
  ConnectionState get connectionState => snapshot.connectionState;
}

extension AsyncValueListenableExtension<T> on ValueListenable<T> {
  /// The async representation of this [ValueListenable].
  AsyncNotifier<T> asAsync() => AsyncNotifier<T>(value);
}
