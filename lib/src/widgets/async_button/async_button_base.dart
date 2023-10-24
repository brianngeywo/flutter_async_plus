import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../flutter_async.dart';
import '../async_state.dart';

class AsyncButton<T extends ButtonStyleButton> extends ButtonStyleButton
    implements AsyncWidget {
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

  /// Returns the [AsyncButtonState] of the nearest [AsyncButton] ancestor or null.
  static AsyncButtonState? maybeOf(BuildContext context) {
    return context.findRootAncestorStateOfType<AsyncButtonState>();
  }

  /// Returns the [AsyncButtonState] of the nearest [AsyncButton] ancestor or throw.
  static AsyncButtonState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'AsyncButton not found');
    return state!;
  }

  static Widget inheritedError(BuildContext context, Object e, StackTrace s) {
    return Async.of(context).config.buttonError.call(context, e, s);
  }

  static Widget inheritedLoader(BuildContext context) {
    return Async.of(context).config.buttonLoader.call(context);
  }

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
