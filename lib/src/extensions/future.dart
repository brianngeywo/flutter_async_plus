import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/async/async.dart';

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

  /// Shows a snackbar on success or error.
  ///
  /// By default, errorMessage overrides Async.message(e).
  Future<T> showSnackBar({
    BuildContext? context,
    String? successMessage,
    String? errorMessage,
  }) {
    context ??= Async.context;

    return then(
      (value) {
        if (successMessage != null) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
        }
        return value;
      },
      onError: (Object e, StackTrace s) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text(errorMessage ?? Async.message(e))),
        );
        throw Error.throwWithStackTrace(e, s);
      },
    );
  }

  /// Shows a loading dialog.
  Future<T> showLoading() async {
    BuildContext? popContext;

    showDialog<void>(
      context: Async.context,
      barrierDismissible: false,
      builder: (context) {
        popContext = context;
        return Async.loadingBuilder(context);
      },
    ).ignore();

    return whenComplete(() {
      if (popContext != null) Navigator.pop(popContext!);
    });
  }
}
