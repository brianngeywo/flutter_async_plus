// ignore_for_file: use_function_type_syntax_for_parameters

part of 'async_button.dart';

class AsyncButtonState<T extends ButtonStyleButton>
    extends AsyncStyleState<AsyncButton<T>, void, ButtonStyle>
    implements AsyncButtonController {
  @override
  bool get isElevatedButton => widget is AsyncButton<ElevatedButton>;
  @override
  bool get isTextButton => widget is AsyncButton<TextButton>;
  @override
  bool get isOutlinedButton => widget is AsyncButton<OutlinedButton>;
  @override
  bool get isFilledButton => widget is AsyncButton<FilledButton>;

  /// Resolves the default [AsyncButtonConfig] of this [T].
  AsyncButtonConfig? get _config {
    if (isFilledButton) return AsyncConfig.of(context).filledButton;
    if (isOutlinedButton) return AsyncConfig.of(context).outlinedButton;
    if (isTextButton) return AsyncConfig.of(context).textButton;
    return AsyncConfig.of(context).elevatedButton;
  }

  /// The current [AsyncButtonConfig] of this button.
  AsyncButtonConfig get config =>
      widget.config ?? _config ?? const AsyncButtonConfig();

  late final errorColor = Theme.of(context).colorScheme.error;

  late final baseStyle =
      (widget.style ?? widget.themeStyleOf(context) ?? const ButtonStyle())
          .merge(widget.defaultStyleOf(context));

  late final errorStyle = baseStyle.copyWith(
    backgroundColor: () {
      if (isOutlinedButton) return null;
      if (isTextButton) return null;
      return MaterialStatePropertyAll(errorColor);
    }(),
    foregroundColor: () {
      if (isElevatedButton) return null;
      if (isFilledButton) return null;
      return MaterialStatePropertyAll(errorColor);
    }(),
  );

  late final loadingStyle = baseStyle.copyWith(
      padding: const MaterialStatePropertyAll(EdgeInsets.zero));

  @override
  AsyncStyle<ButtonStyle> get asyncStyle => AsyncStyle(
        baseStyle: baseStyle,
        errorStyle: errorStyle,
        loadingStyle: loadingStyle,
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

    // Animated child.
    final child = animatedSize(
      child: Builder(
        builder: (context) {
          if (hasError && hasSize) return config.error(context);
          if (isLoading && hasSize) return config.loader(context);
          return widget.child!;
        },
      ),
    );

    return SizedBox.fromSize(
      size: config.keepSize && hasSize ? size : null,
      child: () {
        if (isOutlinedButton) return OutlinedButton.new;
        if (isTextButton) return TextButton.new;
        if (isFilledButton) return FilledButton.new;
        return ElevatedButton.new;
      }()(
        key: widget.key,
        onPressed: widget.onPressed != null ? press : null,
        onLongPress: widget.onLongPress != null ? longPress : null,
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        style: animatedStyle ?? baseStyle,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        statesController: widget.statesController,
        child: child,
      ),
    );
  }
}
