part of 'async_button.dart';

/// Class that defines [AsyncButton] states and styles.
class AsyncButtonConfig {
  const AsyncButtonConfig({
    this.keepSize = false,
    this.animatedSize = const AnimatedSizeConfig(),
    this.errorDuration = const Duration(seconds: 3),
    this.styleDuration = const Duration(seconds: 1),
    this.styleCurve = Curves.fastOutSlowIn,
    this.loader = AsyncButton.inheritedLoader,
    this.error = AsyncButton.inheritedError,
    // this.loadingStyle,
    // this.errorStyle,
  });

  /// Whether or not this button should keep its size when animating.
  final bool keepSize;

  /// The configuration for [AnimatedSize].
  final AnimatedSizeConfig? animatedSize;

  /// The duration to show error widget.
  final Duration errorDuration;

  /// The duration between styles animations.
  final Duration styleDuration;

  /// The curve to use on styles animations.
  final Curve styleCurve;

  /// The widget to show on loading.
  final WidgetBuilder loader;

  /// The widget to show on error.
  final ErrorBuilder error;

  // /// The style to apply on loading.
  // final ButtonStyle? loadingStyle;

  // /// The style to apply on error.
  // final ButtonStyle? errorStyle;
}

/// Class that defines [AsyncButton] loaders.
mixin AsyncButtonLoaders {
  static Widget spinner(BuildContext context) {
    final state = AsyncButton.of(context);

    return CircularProgressIndicator(
      strokeWidth: 2,
      color: () {
        if (state.isOutlinedButton) return null;
        if (state.isTextButton) return null;
        return Theme.of(context).colorScheme.onPrimary;
      }(),
    );
  }
}

/// Class that defines [AsyncButton] errors.
mixin AsyncButtonErrors {
  static Widget text(
      BuildContext context, Object error, StackTrace? stackTrace) {
    final state = AsyncButton.of(context);
    return Text(
      state.errorMessage,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget icon(
      BuildContext context, Object error, StackTrace? stackTrace) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Icon(
      Icons.warning,
      color: errorColor,
    );
  }
}

/// Configuration for [AnimatedSize].
class AnimatedSizeConfig {
  const AnimatedSizeConfig({
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.fastOutSlowIn,
    this.clipBehavior = Clip.hardEdge,
    this.alignment = Alignment.center,
    this.reverseDuration,
  });

  final Duration duration;
  final Curve curve;
  final Clip clipBehavior;
  final Alignment alignment;
  final Duration? reverseDuration;
}
