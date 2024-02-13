import 'package:flutter/material.dart';

import '../../configs/async_config.dart';
import '../async/async.dart';
import 'async_button_builder.dart';

/// Async version of [FloatingActionButton].
class AsyncIconButton extends IconButton {
  /// Creates a new [AsyncIconButton].
  const AsyncIconButton({
    super.key,
    this.config = const AsyncButtonConfig(),
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    required super.onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback,
    super.constraints,
    super.style,
    super.isSelected,
    super.selectedIcon,
    required super.icon,
  });

  /// The config for this [AsyncIconButton].
  final AsyncButtonConfig config;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_cast
    return (this as IconButton).asAsync(config: config);
  }
}

// ignore: library_private_types_in_public_api, public_member_api_docs
extension AsyncFabDuplicateExtension on AsyncIconButton {
  /// Unnecessary duplicate of [asAsync]. Remove this.
  @Deprecated('DUPLICATE, this widget is already asAsync, remove one.')
  Widget asAsync() => this;
}

///
extension AsyncIconButtonExtension on IconButton {
  /// Returns the async version of this [FloatingActionButton].
  ///
  /// - If [config] is set, all other parameters are ignored.
  /// - If any icon widget is set, the respective builder is ignored.
  /// - If any seed color is set, the respective themer is ignored.
  Widget asAsync({
    AsyncButtonConfig? config,
    Widget? loadingIcon,
    Widget? errorIcon,
    Widget? successIcon,
    WidgetBuilder? loadingBuilder,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? successBuilder,
    Color? loadingColor,
    Color? errorColor,
    Color? successColor,
    AsyncThemer? loadingThemer,
    AsyncThemer? errorThemer,
    AsyncThemer? successThemer,
    bool? keepHeight,
    bool? keepWidth,
    bool? animateSize,
    AnimatedSizeConfig? animatedSizeConfig,
    Duration? errorDuration,
    Duration? successDuration,
    Duration? styleDuration,
    Curve? styleCurve,
  }) {
    return AsyncButtonBuilder(
      config: config ??
          AsyncButtonConfig.icon(
            successIcon: successIcon,
            loadingIcon: loadingIcon,
            errorIcon: errorIcon,
            successColor: successColor,
            loadingColor: loadingColor,
            errorColor: errorColor,
          ).copyWith(
            successBuilder: successBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            keepHeight: keepHeight,
            keepWidth: keepWidth,
            animateSize: animateSize,
            animatedSizeConfig: animatedSizeConfig,
            errorDuration: errorDuration,
            successDuration: successDuration,
            styleDuration: styleDuration,
            styleCurve: styleCurve,
            errorThemer: errorThemer,
            loadingThemer: loadingThemer,
            successThemer: successThemer,
          ),
      configurator: (context) => Async.of(context).floatingActionButtonConfig,
      onPressed: onPressed,
      child: icon,
      builder: (context, state, child) {
        return IconButton(onPressed: onPressed, icon: icon);
      },
    );
  }
}
