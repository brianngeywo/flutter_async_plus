import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../configs/async_config.dart';
import '../../utils/adaptive_theme.dart';
import '../async_indicator/async_indicator.dart';

/// A signature for the `AsyncBuilder` function.
typedef DataBuilder<T> = Widget Function(BuildContext context, T data);

/// A signature for the [Async.errorBuilder] function.
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

/// A signature for the [Async.loadingBuilder] function.
typedef AsyncThemeBuilder = ThemeData Function(BuildContext context);

/// Async scope for flutter_async.
class Async extends StatelessWidget {
  /// Creates an [Async] widget.
  const Async({
    super.key,
    required this.config,
    required this.child,
  });

  /// The config to be providen below this [Async].
  final AsyncConfig config;

  /// The child of this [Async].
  final Widget child;

  /// Returns the [AsyncConfig] of the nearest [Async] or default.
  static AsyncConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_InheritedAsync>();
    return scope?.config ?? const AsyncConfig();
  }

  /// Adds a error translator to any [Async.message].
  ///
  /// You can use this to translate errors to a more user-friendly message.
  ///
  /// ```dart
  /// Async.translator = (e) => switch (e) {
  ///   ArgumentError e => '${e.name} is invalid',
  ///   _ => Async.defaultMessage,
  /// }
  /// ```
  static String Function(Object? e) translator = defaultMessage;

  /// Extracts the message of an error.
  ///
  /// This is used by any [Async.errorBuilder]. You can override this
  /// by setting [Async.translator].
  ///
  static String message(Object? e) => translator(e);

  /// The default logger for any error.
  ///
  /// You can override this by setting [Async.errorLogger].
  static void Function(Object e, StackTrace s) errorLogger = (e, s) {
    if (kDebugMode) {
      print(
        'Error caught by [flutter_async]:\n'
        '.message: ${Async.message(e)}\n'
        '.toString(): $e\n',
      );
    }
  };

  /// The library default error message.
  static String defaultMessage(Object? e) {
    try {
      if (e is ParallelWaitError<dynamic, Iterable>) {
        final messages = e.errors.map(Async.message);
        return messages.map((e) => e.endsWith('.') ? e : '$e.').join(' ');
      }
      if (e is Exception) return e.message;
    } catch (_) {}
    return e.toString();
  }

  /// Returns [AsyncConfig.noneBuilder] or default.
  static Widget noneBuilder(BuildContext context) {
    final builder = of(context).noneBuilder;
    if (builder != null) return builder(context);

    // default
    return const Text('-');
  }

  /// Returns [AsyncConfig.errorBuilder] or default.
  static Widget errorBuilder(BuildContext context, Object e, StackTrace s) {
    final builder = of(context).errorBuilder;
    if (builder != null) return builder(context, e, s);

    final message = Async.message(e);

    final layout = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 120) return Text(message);
        return Tooltip(
          message: message,
          child: SizedBox(
            width: constraints.maxWidth,
            child: const Text('!', textAlign: TextAlign.center),
          ),
        );
      },
    );

    return AdaptiveTheme(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [layout],
      ),
    );
  }

  /// Returns [AsyncConfig.loadingBuilder] or default.
  static Widget loadingBuilder(BuildContext context) {
    final builder = of(context).loadingBuilder;
    if (builder != null) return builder(context);

    // default
    return const AsyncIndicator();
  }

  /// Returns [AsyncConfig.reloadingBuilder] or default.
  static Widget reloadingBuilder(BuildContext context) {
    final builder = of(context).reloadingBuilder;
    if (builder != null) return builder(context);

    // default
    return Align(
      alignment: Alignment.topCenter,
      child: AsyncIndicator.linear(),
    );
  }

  /// Returns [AsyncConfig.scrollLoadingBuilder] or default.
  static Widget scrollLoadingBuilder(BuildContext context) {
    final builder = of(context).scrollLoadingBuilder;
    if (builder != null) return builder(context);

    return SizedBox(
      height: 60,
      child: Async.loadingBuilder(context),
    );
  }

  /// Returns the default [ThemeData] for error state.
  @Deprecated('Use errorTheme instead.')
  static ThemeData errorThemer(BuildContext context) => errorTheme(context);

  /// Returns the default [ThemeData] for error state.
  static ThemeData errorTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.colorScheme.error,
        brightness: theme.brightness,
      ),
    );
  }

  /// Returns the default [ThemeData] for loading state.
  @Deprecated('Use loadingTheme instead.')
  static ThemeData loadingThemer(BuildContext context) => loadingTheme(context);

  /// Returns the default [ThemeData] for loading state.
  static ThemeData loadingTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme;
  }

  /// Returns the default [ThemeData] for success state.
  @Deprecated('Use successTheme instead.')
  static ThemeData successThemer(BuildContext context) => successTheme(context);

  /// Returns the default [ThemeData] for success state.
  static ThemeData successTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme;
  }

  /// Shortcut to find the nearest active [BuildContext].
  static BuildContext get context =>
      WidgetsBinding.instance.focusManager.context;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return _InheritedAsync(
          config: config,
          child: child,
        );
      },
    );
  }
}

extension on FocusManager {
  BuildContext get context {
    return primaryFocus?.context ??
        rootScope.focusedChild?.context ??
        rootScope.context!;
  }
}

class _InheritedAsync extends InheritedWidget {
  const _InheritedAsync({
    required this.config,
    required super.child,
  });

  /// The [AsyncConfig] of this [BuildContext].
  final AsyncConfig config;

  @override
  bool updateShouldNotify(_InheritedAsync oldWidget) => false;
}

/// Message of an exception.
extension AsyncMessageException on Exception {
  /// Returns the message of this exception.
  String get message {
    try {
      return (this as dynamic).message as String;
    } catch (_) {
      return toString();
    }
  }
}
