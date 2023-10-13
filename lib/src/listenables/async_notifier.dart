import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_async/flutter_async.dart';

/// Extension to [ValueNotifier] that listens to [Future] and [Stream] events.
///
/// The setters [future] and [stream] set the [AsyncSnapshot] and notify it's
/// listeners.
///
/// Use [AsyncListenable] to expose a [Future] or [Stream] to the view layer. Or
/// simply use the following getters:
///
/// - [isLoading] - Wheter [future] or [stream] is computing for the first time.
/// - [isReloading] - Wheter [future] or [stream] is recomputing.
/// - [hasError] - Wheter [future] or [stream] threw an error.
/// - [hasData] - Wheter [future] or [stream] has data.
/// - [error] - The current error of [future] or [stream].
/// - [stackTrace] - The current [StackTrace] of [future] or [stream].
///
/// Example:
///
/// ```dart
/// class TodoNotifier extends ChangeNotifier {
///  TodoNotifier(this.repository) {
///   _todos.addListener(notifyListeners);
/// }
/// final TodosRepository repository;
///
/// late final _todos = AsyncNotifier(<Todo>[], onData: repository.saveTodos);
///
/// List<Todo> get todos => _todos.value.toList(); //copy list
/// bool get isLoading => _todos.isLoading;
///
/// void addTodo(Todo todo) {
///  _todos.value = todos..add(todo);
/// }
/// ```
class AsyncNotifier<T> extends ValueNotifier<T> implements AsyncListenable<T> {
  /// Creates an [AsyncNotifier] with [value] and optional callbacks.
  ///
  /// - [onData] is only called when [AsyncSnapshot] resolves with new data.
  /// - [onError] is called whenever [AsyncSnapshot] resolves with error.
  ///
  /// The `late` keyword is useful when using [onData]/[onError] callbacks. Ex:
  /// ```dart
  /// late final _todos = AsyncNotifier(<Todo>[], onData: repository.saveTodos);
  /// ```
  AsyncNotifier(super._value, {this.onData, this.onError})
      : _snapshot = AsyncSnapshot.withData(ConnectionState.none, _value);

  /// Called when [AsyncSnapshot] resolves with new data.
  final DataChanged<T>? onData;

  /// Called whenever [AsyncSnapshot] resolves with error.
  final ErrorCallback? onError;

  Future<T>? _future;
  Stream<T>? _stream;
  AsyncSnapshot<T> _snapshot;
  StreamSubscription<T>? _subscription;

  @override
  AsyncSnapshot<T> get snapshot => _snapshot;

  @override
  Future<T> get future => _future ?? Future.value(value);

  @override
  Stream<T> get stream => _stream ?? Stream.value(value);

  @override
  set value(T value) {
    if (super.value == value) return;
    snapshot = AsyncSnapshot.withData(snapshot.connectionState, value);
  }

  @visibleForTesting
  set snapshot(AsyncSnapshot<T> snapshot) {
    if (_snapshot == snapshot) return;
    final data = (_snapshot = snapshot).data;

    if (data is T && data != value && !hasError) {
      super.value = data;
      onData?.call(data);
      return; // prevent notifyListeners since super.value already did.
    }
    notifyListeners();
  }

  /// Sets this notifier for each [AsyncSnapshot] event of [future].
  set future(Future<T> future) {
    if (_future == future) return;
    _unsubscribe();

    _future = future;
    snapshot = _snapshot.inState(ConnectionState.waiting);

    future.then(
      (data) {
        if (_future != future) return;
        snapshot = AsyncSnapshot.withData(ConnectionState.done, data);
      },
      onError: (e, s) {
        if (_future != future) return;
        snapshot = AsyncSnapshot.withError(ConnectionState.done, e, s);
        onError?.call(e, s);
      },
    );
  }

  /// Sets this notifier for each [AsyncSnapshot] event of [stream].
  set stream(Stream<T> stream) {
    if (_stream == stream) return;
    _unsubscribe();

    _stream = stream;
    snapshot = _snapshot.inState(ConnectionState.waiting);

    _subscription = stream.listen(
      (data) {
        snapshot = AsyncSnapshot.withData(ConnectionState.active, data);
      },
      onError: (e, s) {
        snapshot = AsyncSnapshot.withError(ConnectionState.active, e, s);
        onError?.call(e, s);
      },
      onDone: () {
        snapshot = _snapshot.inState(ConnectionState.done);
      },
    );
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
    _stream = null;
    _future = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
