import 'package:flutter/animation.dart';

import '../animated_style_mixin.dart';

class AsyncStyle<T> {
  // Styles.
  final T baseStyle;
  final T errorStyle;
  final T loadingStyle;

  // Animation.
  final Duration? styleDuration;
  final Duration? errorDuration;
  final Curve styleCurve;
  final LerpCallback<T> lerp;

  const AsyncStyle({
    required this.baseStyle,
    required this.errorStyle,
    required this.loadingStyle,
    this.styleDuration = const Duration(milliseconds: 300),
    this.errorDuration = const Duration(seconds: 3),
    this.styleCurve = Curves.fastOutSlowIn,
    required this.lerp,
  });
}
