// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../flutter_async.dart';
import '../animated_style_mixin.dart';

part 'async_button_config.dart';
part 'async_button_state.dart';

class AsyncElevatedButton extends AsyncButton<ElevatedButton> {
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
