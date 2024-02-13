import 'package:flutter/material.dart';

import '../../flutter_async.dart';

/// The configuration of [AsyncFloatingActionButton].
class AsyncFloatingActionButtonConfig {
  /// Creates a new [AsyncFloatingActionButtonConfig].
  const AsyncFloatingActionButtonConfig({
    this.errorDuration,
    this.styleDuration,
    this.styleCurve,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// The duration to show error widget.
  final Duration? errorDuration;

  /// The duration between styles animations.
  final Duration? styleDuration;

  /// The curve to use on styles animations.
  final Curve? styleCurve;

  /// The widget to show on loading.
  final WidgetBuilder? loadingBuilder;

  /// The widget to show on error.
  final ErrorBuilder? errorBuilder;
}
