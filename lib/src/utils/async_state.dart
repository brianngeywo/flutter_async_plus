import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

/// A [State] with an [AsyncNotifier].
abstract class AsyncState<T extends StatefulWidget, Data> extends State<T> {
  /// The [AsyncNotifier] of this state.
  @protected
  late final async = AsyncNotifier<Data>(data: initialData);

  /// The initial data of this state.
  Data? get initialData => null;

  /// The [AsyncSnapshot] of this state.
  AsyncSnapshot<Data> get snapshot => async.snapshot;

  /// Called whenever [AsyncSnapshot] changes.
  void onSnapshot(AsyncSnapshot<Data> snapshot) {}

  @override
  void initState() {
    super.initState();
    async.addListener(() => setState(() => onSnapshot(snapshot)));
  }

  @override
  void dispose() {
    async.dispose();
    super.dispose();
  }
}
