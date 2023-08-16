import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../flutter_async.dart';

class AsyncConfig {
  const AsyncConfig({
    this.elevatedButton,
    this.filledButton,
    this.textButton,
    this.outlinedButton,
  });

  final AsyncButtonConfig? elevatedButton;
  final AsyncButtonConfig? filledButton;
  final AsyncButtonConfig? textButton;
  final AsyncButtonConfig? outlinedButton;

  static AsyncConfig of(BuildContext context) {
    return maybeOf(context) ?? const AsyncConfig();
  }

  static AsyncConfig? maybeOf(BuildContext context) {
    return Async.maybeOf(context)?.config;
  }

  AsyncConfig copyWith({
    AsyncButtonConfig? elevatedButton,
    AsyncButtonConfig? filledButton,
    AsyncButtonConfig? textButton,
    AsyncButtonConfig? outlinedButton,
  }) {
    return AsyncConfig(
      elevatedButton: elevatedButton ?? this.elevatedButton,
      filledButton: filledButton ?? this.filledButton,
      textButton: textButton ?? this.textButton,
      outlinedButton: outlinedButton ?? this.outlinedButton,
    );
  }

  /// Merges this [AsyncConfig] with [config]
  AsyncConfig merge(AsyncConfig? config) {
    if (config == null) {
      return this;
    }
    return copyWith(
      elevatedButton: elevatedButton ?? config.elevatedButton,
      filledButton: filledButton ?? config.filledButton,
      textButton: textButton ?? config.textButton,
      outlinedButton: outlinedButton ?? config.outlinedButton,
    );
  }
}
