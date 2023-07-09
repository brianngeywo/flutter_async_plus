// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../flutter_async.dart';

extension AsyncButtonExtension<T extends ButtonStyleButton> on T {
  /// The Async version of this [ButtonStyleButton].
  AsyncButton<T> async({
    List<ValueListenable<bool>> listenables = const [],
    AsyncController? controller,
    AsyncButtonConfig? config,
  }) =>
      AsyncButton<T>(
        //Extended.
        listenables: listenables,
        controller: controller,
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
        child: child!,
      );
}
