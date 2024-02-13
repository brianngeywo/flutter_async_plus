import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

/// A [State] with an [AsyncNotifier].
abstract class AsyncState<T extends StatefulWidget, Data> extends State<T> {
  /// The [AsyncNotifier] of this state.
  late final async = AsyncNotifier.late<Data>(
    value: initialData,
    onError: onError,
    onData: onData,
  );

  /// The initial data of this state.
  Data? get initialData => null;

  /// Called whenever [AsyncSnapshot] resolves with error.
  @protected
  @mustCallSuper
  void onError(Object error, StackTrace? stackTrace) {}

  /// Called when [AsyncSnapshot] resolves with new data.
  @protected
  @mustCallSuper
  void onData(Data data) {}

  /// Called whenever [AsyncSnapshot] changes.
  void onSnapshot(AsyncSnapshot<Data> snapshot) {}

  /// Performs [AsyncNotifier.cancel] on current async computation.
  @mustCallSuper
  void cancel() => async.cancel();

  @override
  void initState() {
    super.initState();
    async.addListener(() => setState(() => onSnapshot(async.snapshot)));
  }

  @override
  void dispose() {
    async.dispose();
    super.dispose();
  }
}
