// ignore_for_file: prefer_function_declarations_over_variables

part of 'async_button.dart';

/// Base class for [AsyncButton] widget implementations.
abstract class AsyncButton<T extends ButtonStyleButton>
    extends ButtonStyleButton {
  /// Creates [AsyncButton] of a [ButtonStyleButton].
  ///
  /// Behaves exactly like the [ButtonStyleButton] counterpart. Except that
  /// [onPressed] and [onLongPress] are now tracked when they are async.
  ///
  /// Each async state is handled by [AsyncConfig].
  ///
  /// - Loading:
  /// [AsyncButtonConfig.loadingBuilder], fallbacks to [AsyncConfig.loadingBuilder].
  ///
  /// - Error:
  /// [AsyncButtonConfig.errorBuilder], fallbacks to [AsyncConfig.errorBuilder].
  ///
  /// By default, [AsyncButton] will show a [CircularProgressIndicator] when
  /// loading and a [Text] with the error when an error occurs.
  ///
  const AsyncButton({
    super.key,
    this.config,
    required super.onPressed,
    required super.onLongPress,
    required super.onHover,
    required super.onFocusChange,
    required super.style,
    required super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.hardEdge,
    super.statesController,
    required super.child,
  });

  /// The config of [AsyncButton].
  final AsyncButtonConfig? config;

  /// Returns the first [AsyncButtonState] above this [context].
  static AsyncButtonState<T> of<T extends ButtonStyleButton>(
    BuildContext context,
  ) {
    final state = context.findAncestorStateOfType<AsyncButtonState<T>>();
    assert(state != null, 'No AsyncButton of this context');
    return state!;
  }

  /// Returns the first [AsyncButtonState] below this [context].
  /// Filters by [key], if given.
  static AsyncButtonState<T> at<T extends ButtonStyleButton>(
    BuildContext context, {
    Key? key,
  }) {
    return context.visitState(
      assertType: 'AsyncButton',
      filter: (state) => key == null || state.widget.key == key,
    );
  }

  static const _to = {
    TextButton: TextButton.new,
    FilledButton: FilledButton.new,
    ElevatedButton: ElevatedButton.new,
    OutlinedButton: OutlinedButton.new,
  };

  static const _from = {
    TextButton: AsyncTextButton.new,
    FilledButton: AsyncFilledButton.new,
    ElevatedButton: AsyncElevatedButton.new,
    OutlinedButton: AsyncOutlinedButton.new,
  };

  static final _config = {
    TextButton: (BuildContext c) => Async.of(c).textButtonConfig,
    FilledButton: (BuildContext c) => Async.of(c).filledButtonConfig,
    ElevatedButton: (BuildContext c) => Async.of(c).elevatedButtonConfig,
    OutlinedButton: (BuildContext c) => Async.of(c).outlinedButtonConfig,
  };

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final button = _to[T].orThrow(child: this, onPressed: null);
    return button.defaultStyleOf(context);
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    final button = _to[T].orThrow(child: this, onPressed: null);
    return button.themeStyleOf(context);
  }

  /// The resolved style of [AsyncButton].
  ButtonStyle styleOf(BuildContext context) {
    var style = const ButtonStyle();

    style = style.merge(this.style);
    style = style.merge(themeStyleOf(context));
    style = style.merge(defaultStyleOf(context));

    return style;
  }

  /// The resolved config of [AsyncButton].
  AsyncButtonResolvedConfig configOf(BuildContext context) {
    var config = const AsyncButtonConfig();

    config = config.merge(this.config);
    config = config.merge(_config[T]?.call(context));
    config = config.merge(Async.of(context).buttonConfig);
    config = config.copyWith(
      errorBuilder: config.errorBuilder ?? Async.errorBuilder,
      loadingBuilder: config.loadingBuilder ?? Async.loadingBuilder,
    );

    return config.resolve();
  }

  @override
  State<AsyncButton<T>> createState() => AsyncButtonState<T>();
}
