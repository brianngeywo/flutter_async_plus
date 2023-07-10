// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

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
    super.config,
    super.controller,
    super.listenables,

    //Base.
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.statesController,
    super.child,
  });
}

class AsyncOutlinedButton extends AsyncButton<OutlinedButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncOutlinedButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;

  const AsyncOutlinedButton({
    //Extended.
    super.config,
    super.controller,
    super.listenables,

    //Base.
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.statesController,
    super.child,
  });
}

class AsyncTextButton extends AsyncButton<TextButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncTextButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;

  const AsyncTextButton({
    //Extended.
    super.config,
    super.controller,
    super.listenables,

    //Base.
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.statesController,
    super.child,
  });
}

class AsyncFilledButton extends AsyncButton<FilledButton> {
  static AsyncButtonConfig? _config;

  /// The default [AsyncButtonConfig] for [AsyncFilledButton].
  static void setConfig(AsyncButtonConfig config) => _config = config;
  const AsyncFilledButton({
    //Extended.
    super.config,
    super.controller,
    super.listenables,

    //Base.
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.statesController,
    super.child,
  });
}
