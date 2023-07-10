import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

import '../async_state.dart';

class AsyncButton<T extends ButtonStyleButton> extends ButtonStyleButton
    implements AsyncWidget {
  static var baseConfig = const AsyncButtonConfig();

  /// The default [AsyncButtonConfig] of all RxButton's.
  static void setConfig(AsyncButtonConfig config) => baseConfig = config;

  const AsyncButton({
    //Extended.
    this.config,
    this.controller,
    this.listenables = const [],

    //Base.
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    super.child,
  });

  /// The configs of [AsyncButton]. Prefer setting AsyncButton<Type>.setConfig().
  final AsyncButtonConfig? config;

  @override
  final AsyncController? controller;

  @override
  final List<ValueListenable<bool>> listenables;

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    if (this is AsyncButton<OutlinedButton>) {
      return const OutlinedButton(onPressed: null, child: Text(''))
          .defaultStyleOf(context);
    }
    if (this is AsyncButton<FilledButton>) {
      return const FilledButton(onPressed: null, child: Text(''))
          .defaultStyleOf(context);
    }
    if (this is AsyncButton<TextButton>) {
      return const TextButton(onPressed: null, child: Text(''))
          .defaultStyleOf(context);
    }
    return const ElevatedButton(onPressed: null, child: Text(''))
        .defaultStyleOf(context);
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    if (this is AsyncButton<OutlinedButton>) {
      return OutlinedButtonTheme.of(context).style;
    }

    if (this is AsyncButton<FilledButton>) {
      return FilledButtonTheme.of(context).style;
    }
    if (this is AsyncButton<TextButton>) {
      return TextButtonTheme.of(context).style;
    }
    return ElevatedButtonTheme.of(context).style;
  }

  @override
  State<AsyncButton<T>> createState() => AsyncButtonState<T>();
}
