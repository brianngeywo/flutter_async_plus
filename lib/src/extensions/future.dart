import 'dart:async';

///
extension AsyncFutureExtension<T> on Future<T> {
  /// Completes either with [onValue] or null.
  Future<T?> thenOrNull(FutureOr<T?> Function(T value) onValue) {
    return then((value) => onValue(value), onError: (_) => null);
  }

  /// Silently catches errors and returns null.
  Future<T?> orNull() {
    return thenOrNull((value) => value);
  }

  /// Completes with either `true` or `false`.
  Future<bool> orFalse() {
    return then((_) => true, onError: (_) => false);
  }
}
