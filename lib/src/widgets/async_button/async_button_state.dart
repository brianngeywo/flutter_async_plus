part of 'async_button.dart';

/// The [AsyncState] of [AsyncButton].
class AsyncButtonState<T extends ButtonStyleButton>
    extends AsyncState<AsyncButton<T>, void> {
  AsyncButtonResolvedConfig get _config => widget.configOf(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _size = context.size);
  }

  /// Invokes [AsyncButton.onPressed] programatically.
  void press() {
    if (widget.onPressed != null) {
      _cancelTimer?.cancel();
      async.future = Future(widget.onPressed!);
    }
  }

  /// Invokes [AsyncButton.onLongPress] programatically.
  void longPress() {
    if (widget.onLongPress != null) {
      _cancelTimer?.cancel();
      async.future = Future(widget.onLongPress!);
    }
  }

  @override
  void onError(Object error, StackTrace? stackTrace) {
    super.onError(error, stackTrace);
    _cancelTimer?.cancel();
    _cancelTimer = Timer(_config.errorDuration, cancel);
  }

  Timer? _cancelTimer;
  Size? _size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var style = widget.styleOf(context);

    // ? (arthurbcd): maybe callback the styles ?
    style = async.snapshot.when(
      data: (_) => style,
      loading: () => style,
      error: (e, s) => style.copyWith(
        backgroundColor: () {
          if (T == OutlinedButton) return null;
          if (T == TextButton) return null;
          return MaterialStatePropertyAll(theme.colorScheme.error);
        }(),
        foregroundColor: () {
          if (T == ElevatedButton) return null;
          if (T == FilledButton) return null;
          return MaterialStatePropertyAll(theme.colorScheme.error);
        }(),
      ),
    );

    var child = async.snapshot.when(
      data: (_) => widget.child,
      error: (e, s) => _config.errorBuilder(context, e, s),
      loading: () => _config.loadingBuilder(context),
    );

    if (_config.animateSize) {
      child = AnimatedSize(
        alignment: _config.animatedSizeConfig.alignment,
        duration: _config.animatedSizeConfig.duration,
        reverseDuration: _config.animatedSizeConfig.reverseDuration,
        curve: _config.animatedSizeConfig.curve,
        clipBehavior: _config.animatedSizeConfig.clipBehavior,
        child: child,
      );
    }

    child = AnimatedValue<ButtonStyle?>(
      value: style,
      duration: _config.styleDuration,
      curve: _config.styleCurve,
      lerp: ButtonStyle.lerp,
      builder: (context, style, child) {
        return AsyncButton._to[T].orThrow(
          style: style,
          onPressed: widget.onPressed != null ? press : null,
          onLongPress: widget.onLongPress != null ? longPress : null,
          onHover: widget.onHover,
          onFocusChange: widget.onFocusChange,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          clipBehavior: widget.clipBehavior,
          statesController: widget.statesController,
          child: child ?? const SizedBox.shrink(),
        );
      },
      child: child,
    );

    if (_config.keepHeight || _config.keepWidth) {
      child = SizedBox(
        height: _config.keepHeight ? _size?.height : null,
        width: _config.keepWidth ? _size?.width : null,
        child: child,
      );
    }

    return child;
  }
}

extension<T extends Object> on T? {
  T get orThrow {
    assert(this != null, 'Type $T is not supported. Please, open an issue.');
    if (this == null) throw ArgumentError.notNull('$T');
    return this!;
  }
}
