import 'package:flutter/material.dart';

/// A [Theme] based on parent widget's background color.
class AdaptiveTheme extends StatelessWidget {
  /// Creates an [AdaptiveTheme] widget.
  ///
  /// The [fallback] theme is used when the parent widget's background color has
  /// a contrast ratio lower than [recommendedContrastRatio].
  ///
  /// If [fallback] is null and [recommendedContrastRatio] is not met, the
  /// [ThemeData] of the nearest [Theme] ancestor will be used and the colors
  /// primary and onPrimary will be swapped if ratio is higher on primary.
  ///
  /// This widget visits the ancestor elements to find the parent widget's
  /// background color. If the parent widget's background color is transparent,
  /// it will continue to visit the ancestor elements until it finds a non
  /// transparent color.
  ///
  /// Widgets like painters, images, and videos are not supported.
  ///
  const AdaptiveTheme({
    super.key,
    this.fallback,
    this.recommendedContrastRatio = 4.5,
    required this.child,
  });

  /// The fallback [ThemeData].
  final ThemeData? fallback;

  /// The contrast ratio to compare with the parent widget's background color.
  final double recommendedContrastRatio;

  /// The child of this [AdaptiveTheme].
  final Widget child;

  /// Returns the contrast ratio between two colors.
  double getContrastRatio(Color a, Color b) {
    final luminanceA = a.computeLuminance();
    final luminanceB = b.computeLuminance();
    return (luminanceA > luminanceB)
        ? (luminanceA + 0.05) / (luminanceB + 0.05)
        : (luminanceB + 0.05) / (luminanceA + 0.05);
  }

  @override
  Widget build(BuildContext context) {
    Color? color;

    context.visitAncestorElements((element) {
      final widget = element.widget;

      if (widget is Material) color = widget.color;
      if (widget is PhysicalModel) color = widget.color;
      if (widget is PhysicalShape) color = widget.color;
      if (widget is ColoredBox) color = widget.color;
      if (widget is DecoratedBox && widget.decoration is BoxDecoration) {
        color = (widget.decoration as BoxDecoration).color;
      }

      if (color != null && color!.alpha != 0) {
        return false;
      }
      return true;
    });

    var scheme = fallback?.colorScheme ?? Theme.of(context).colorScheme;
    final background = color ?? Colors.transparent;

    final contrastPrimary = getContrastRatio(background, scheme.primary);
    final contrastOnPrimary = getContrastRatio(background, scheme.onPrimary);

    if (contrastPrimary < recommendedContrastRatio) {
      // swap colors if the contrast ratio is higher on primary
      scheme = contrastPrimary >= contrastOnPrimary
          ? scheme
          : scheme.copyWith(
              primary: scheme.onPrimary,
              onPrimary: scheme.primary,
            );
    }

    return Theme(
      data: Theme.of(context).copyWith(colorScheme: scheme),
      child: child,
    );
  }
}
