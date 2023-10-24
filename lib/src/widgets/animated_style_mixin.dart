// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

import 'async_state.dart';

class AsyncStyle<T> {

  const AsyncStyle({
    required this.baseStyle,
    required this.errorStyle,
    required this.loadingStyle,
    this.styleDuration = const Duration(milliseconds: 300),
    this.errorDuration = const Duration(seconds: 3),
    this.styleCurve = Curves.fastOutSlowIn,
    required this.lerp,
  });
  // Styles.
  final T baseStyle;
  final T errorStyle;
  final T loadingStyle;

  // Animation.
  final Duration? styleDuration;
  final Duration? errorDuration;
  final Curve styleCurve;
  final LerpCallback<T> lerp;
}

abstract class AsyncStyleState<W extends AsyncWidget<T>, T, S>
    extends AsyncState<W, T>
    with TickerProviderStateMixin, AnimatedStyleMixin<W, S> {
  /// The [AsyncStyle] of this widget.
  AsyncStyle<S> get asyncStyle;

  @override
  Duration? get errorDuration => asyncStyle.errorDuration;

  @override
  Duration? get styleDuration => asyncStyle.styleDuration;

  @override
  Curve get styleCurve => asyncStyle.styleCurve;

  /// The resolved styled [T] value.
  S get style {
    if (hasError) return asyncStyle.errorStyle;
    if (isLoading) return asyncStyle.loadingStyle;
    return asyncStyle.baseStyle;
  }

  @override
  S? lerp(S begin, S end, double t) => asyncStyle.lerp(begin, end, t);

  @override
  void setLoading(bool isLoading) {
    super.setLoading(isLoading);
    setStyle(style);
  }

  @override
  void setError(bool hasError, [Object? error, StackTrace? stackTrace]) {
    super.setError(hasError, error, stackTrace);
    setStyle(style);
  }
}

mixin AnimatedStyleMixin<W extends StatefulWidget, S>
    on TickerProviderStateMixin<W> {
  late final _ac = AnimationController(vsync: this, duration: styleDuration);
  late final _curve = CurvedAnimation(parent: _ac, curve: styleCurve);
  Animation<S>? _style;
  Size? _size;

  /// The size of the widget.
  Size get size => _size!;

  /// Whether the widget has a size.
  bool get hasSize => _size != null;

  /// The animated [S] value.
  S? get animatedStyle => _style?.value;

  /// The [S] lerp function.
  S? lerp(S begin, S end, double t);

  /// The duration of the style animation.
  Duration? get styleDuration;

  /// The curve of the style animation.
  Curve get styleCurve;

  /// Sets the [S] value to animate to.
  void setStyle(S newStyle) {
    _style = lerp.tween(_style?.value, newStyle).animate(_curve);

    if (mounted && hasSize) _ac.forward(from: 0);
  }

  WidgetsBinding? get _binding => WidgetsBinding.instance;

  @override
  void initState() {
    super.initState();
    _binding?.addPostFrameCallback((_) {
      _size ??= context.size;
      _ac.addListener(() => setState(() {}));
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }
}

class UniversalTween<T extends Object> extends Tween<T> {
  UniversalTween({
    required T begin,
    required T end,
  }) : super(begin: begin, end: end);

  @override
  T lerp(double t) {
    final dynamic begin = this.begin;
    final dynamic end = this.end;

    if (begin is EdgeInsets && end is EdgeInsets) {
      return EdgeInsets.lerp(begin, end, t)! as T;
    } else if (begin is Color && end is Color) {
      return Color.lerp(begin, end, t)! as T;
    } else if (begin is Rect && end is Rect) {
      return Rect.lerp(begin, end, t)! as T;
    } else if (begin is Size && end is Size) {
      return Size.lerp(begin, end, t)! as T;
    } else if (begin is double && end is double) {
      return (begin + (end - begin) * t) as T;
    } else {
      throw ArgumentError(
        'Cannot interpolate between values of type ${begin.runtimeType}.',
      );
    }
  }
}

class LerpTween<T> extends Tween<T> {
  LerpTween({
    required T begin,
    required T end,
    required this.lerper,
  }) : super(begin: begin, end: end);

  final T Function(T begin, T end, double t) lerper;

  @override
  T lerp(double t) => lerper(begin as T, end as T, t);
}

class SelectTween<T extends Object> extends Tween<T> {
  SelectTween({
    required T super.begin,
    required super.end,
    required this.select,
    required this.adapter,
  });

  final List<Object> Function(T data) select;
  final T Function(List values) adapter;

  @override
  T lerp(double t) {
    if (end == null) return begin!;

    final begins = select(begin!);
    final ends = select(end!);

    final values = List.generate(
      ends.length,
      (i) => UniversalTween(begin: begins[i], end: ends[i]).lerp(t),
    );

    return adapter(values);
  }
}

typedef LerpCallback<T extends Object?> = T? Function(T begin, T end, double t);

extension TweenExtension<T> on LerpCallback<T> {
  /// Creates a [LerpTween] with the given [begin] and [end] values.
  Tween<T> tween(T? begin, T? end) {
    return LerpTween<T>(
      begin: begin ?? end!,
      end: end ?? begin!,
      lerper: (begin, end, t) => this(begin, end, t) ?? end ?? begin,
    );
  }
}
