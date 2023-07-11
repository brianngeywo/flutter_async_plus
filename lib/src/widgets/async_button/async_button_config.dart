part of 'async_button.dart';

typedef AsyncWidgetBuilder = Widget Function(
    BuildContext context, AsyncButtonController state);

/// Class that defines [AsyncButton] states and styles.
class AsyncButtonConfig {
  const AsyncButtonConfig({
    this.keepSize = false,
    this.animatedSize = const AnimatedSizeConfig(),
    this.errorDuration = const Duration(seconds: 3),
    this.styleDuration = const Duration(seconds: 1),
    this.styleCurve = Curves.fastOutSlowIn,
    this.loader = AsyncButtonLoaders.spinner,
    this.error = AsyncButtonErrors.text,
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
  final Widget Function(BuildContext context, AsyncButtonController state)
      loader;

  /// The widget to show on error.
  final Widget Function(BuildContext context, AsyncButtonController state)
      error;

  // /// The style to apply on loading.
  // final ButtonStyle? loadingStyle;

  // /// The style to apply on error.
  // final ButtonStyle? errorStyle;
}

/// Class that defines [AsyncButton] loaders.
mixin AsyncButtonLoaders {
  static Widget spinner(BuildContext context, AsyncButtonController button) {
    return SizedBox.square(
      dimension: button.size.height / 2,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: () {
          if (button.isOutlinedButton) return null;
          if (button.isTextButton) return null;
          return Theme.of(context).colorScheme.onPrimary;
        }(),
      ),
    );
  }
}

/// Class that defines [AsyncButton] errors.
mixin AsyncButtonErrors {
  static Widget text(BuildContext context, AsyncButtonController controller) {
    return Text(
      controller.errorMessage,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget icon(BuildContext context, AsyncButtonController controller) {
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
