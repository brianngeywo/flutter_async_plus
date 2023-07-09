// ignore_for_file: use_function_type_syntax_for_parameters

part of 'async_button.dart';

class AsyncButtonState<T extends ButtonStyleButton>
    extends AsyncStyleState<AsyncButton<T>, void, ButtonStyle> {
  /// Resolves the default [AsyncButtonConfig] of this [T].
  AsyncButtonConfig? get _config {
    final config = () {
      if (isFilledButton) return AsyncFilledButton._config;
      if (isOutlinedButton) return AsyncOutlinedButton._config;
      if (isTextButton) return AsyncTextButton._config;
      return AsyncElevatedButton._config;
    }();

    final theme = widget.themeStyleOf(context);
    return config ?? (theme is AsyncButtonStyle ? theme.config : null);
  }

  /// The current [AsyncButtonConfig] of this button.
  AsyncButtonConfig get config =>
      widget.config ?? _config ?? AsyncButton.baseConfig;

  late final baseStyle =
      (widget.style ?? widget.themeStyleOf(context) ?? const ButtonStyle())
          .merge(widget.defaultStyleOf(context));

  @override
  AsyncStyle<ButtonStyle> get asyncStyle => AsyncStyle(
        baseStyle: baseStyle,
        errorStyle: config.errorStyle(context, this, baseStyle),
        loadingStyle: config.loadingStyle(context, this, baseStyle),
        errorDuration: config.errorDuration,
        styleDuration: config.styleDuration,
        styleCurve: config.styleCurve,
        lerp: ButtonStyle.lerp,
      );

  /// The child of this button.
  Widget get child => widget.child!;

  @override
  Future<void> reload() => press(); // default action.

  @override
  Future<void> press() => setAction(widget.onPressed!);

  @override
  Future<void> longPress() => setAction(widget.onLongPress!);

  // late final _controller = AsyncButtonController()..attach(this);

  @override
  Widget build(BuildContext context) {
    Widget animatedSize({required Widget child}) {
      if (config.animatedSize == null) return child;

      return AnimatedSize(
        curve: config.animatedSize!.curve,
        duration: config.animatedSize!.duration,
        alignment: config.animatedSize!.alignment,
        clipBehavior: config.animatedSize!.clipBehavior,
        reverseDuration: config.animatedSize!.reverseDuration,
        child: child,
      );
    }

    // Actions.
    final onPressed = widget.onPressed != null ? press : null;
    final onLongPress = widget.onLongPress != null ? longPress : null;

    // Animated style.
    final style = animatedStyle ?? baseStyle;

    // Animated child.
    final child = animatedSize(
      child: () {
        if (hasError && hasSize) return config.error(context, this);
        if (isLoading && hasSize) return config.loader(context, this);
        return widget.child!;
      }(),
    );

    return SizedBox.fromSize(
      size: config.keepSize && hasSize ? size : null,
      child: () {
        if (isOutlinedButton) {
          return OutlinedButton(
            key: widget.key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: widget.onHover,
            onFocusChange: widget.onFocusChange,
            style: style,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            clipBehavior: widget.clipBehavior,
            statesController: widget.statesController,
            child: child,
          );
        }
        if (isTextButton) {
          return TextButton(
            key: widget.key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: widget.onHover,
            onFocusChange: widget.onFocusChange,
            style: style,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            clipBehavior: widget.clipBehavior,
            statesController: widget.statesController,
            child: child,
          );
        }
        if (isFilledButton) {
          return FilledButton(
            key: widget.key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: widget.onHover,
            onFocusChange: widget.onFocusChange,
            style: style,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            clipBehavior: widget.clipBehavior,
            statesController: widget.statesController,
            child: child,
          );
        }
        return ElevatedButton(
          key: widget.key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          onFocusChange: widget.onFocusChange,
          style: style,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          clipBehavior: widget.clipBehavior,
          statesController: widget.statesController,
          child: child,
        );
      }(),
    );
  }
}
