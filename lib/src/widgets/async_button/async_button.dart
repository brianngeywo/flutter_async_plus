// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../flutter_async.dart';
import '../animated_style_mixin.dart';

part 'async_button_config.dart';
part 'async_button_style.dart';
part 'async_button_state.dart';

class AsyncElevatedButton extends AsyncButton<ElevatedButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncElevatedButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;

  const AsyncElevatedButton({
    //Extended.
    AsyncButtonConfig? config,
    AsyncController? controller,
    List<ValueListenable<bool>> listenables = const [],

    //Base.
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    required Widget child,
  }) : super(
          //Extended.
          config: config,
          controller: controller,
          listenables: listenables,

          //Base.
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          statesController: statesController,
          child: child,
        );
}

class AsyncOutlinedButton extends AsyncButton<OutlinedButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncOutlinedButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;

  const AsyncOutlinedButton({
    //Extended.
    AsyncButtonConfig? config,
    AsyncController? controller,
    List<ValueListenable<bool>> listenables = const [],

    //Base.
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    required Widget child,
  }) : super(
          //Extended.
          config: config,
          controller: controller,
          listenables: listenables,

          //Base.
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          statesController: statesController,
          child: child,
        );
}

class AsyncTextButton extends AsyncButton<TextButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncTextButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;

  const AsyncTextButton({
    //Extended.
    AsyncButtonConfig? config,
    AsyncController? controller,
    List<ValueListenable<bool>> listenables = const [],

    //Base.
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    required Widget child,
  }) : super(
          //Extended.
          config: config,
          controller: controller,
          listenables: listenables,

          //Base.
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          statesController: statesController,
          child: child,
        );
}

class AsyncFilledButton extends AsyncButton<FilledButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncFilledButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;
  const AsyncFilledButton({
    //Extended.
    AsyncButtonConfig? config,
    AsyncController? controller,
    List<ValueListenable<bool>> listenables = const [],

    //Base.
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    required Widget child,
  }) : super(
          //Extended.
          config: config,
          controller: controller,
          listenables: listenables,

          //Base.
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          statesController: statesController,
          child: child,
        );
}
