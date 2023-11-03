// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:animated_value/animated_value.dart';
import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';

import '../../configs/async_config.dart';
import '../../extensions/context.dart';
import '../../utils/async_state.dart';
import '../async/async.dart';

part 'async_button_base.dart';
part 'async_button_impl.dart';
part 'async_button_state.dart';

/// Adapts [ButtonStyleButton] to [AsyncButton].
extension AsyncButtonExtension<T extends ButtonStyleButton> on T {
  /// The Async version of this [ButtonStyleButton].
  ///
  /// Behaves exactly like the [ButtonStyleButton] counterpart. Except that
  /// [onPressed] and [onLongPress] are now tracked when they are async.
  ///
  /// Each async state is handled by [AsyncButtonConfig].
  ///
  AsyncButton<T> asAsync({
    AsyncButtonConfig? config,
  }) =>
      AsyncButton._from[T].orThrow(
        //Extended.
        config: config,

        //Base.
        key: key,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        onPressed: onPressed,
        style: style,
        statesController: statesController,
        child: child,
      ) as AsyncButton<T>;
}

///Duplicate warning.
extension AsyncButtonDuplicateExtension<T extends AsyncButton> on T {
  /// Unnecessary duplicate of [asAsync]. Remove this.
  @Deprecated('DUPLICATE, this widget is already an AsyncButton, remove one.')
  AsyncButton asAsync() => this;
}
