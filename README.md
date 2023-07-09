# Flutter Async

Flutter Async is a Flutter package designed to manage asynchronous tasks in Flutter effectively. With widgets like AsyncBuilder, AsyncElevatedButton, AsyncFilledButton, AsyncTextButton, and AsyncOutlinedButton, developers can handle tasks such as fetching data from an API or running computations in the background with ease. This package provides built-in loaders and error handlers, and allows you to create custom handlers as needed.

## Features

- **AsyncBuilder:** A widget for building interfaces based on Future or Stream data sources. It provides built-in handling for loading and error states, as well as a mechanism for automatic or user-triggered retries.
- **AsyncButton (AsyncElevatedButton, AsyncFilledButton, AsyncTextButton, AsyncOutlinedButton):** Buttons that trigger asynchronous actions. These buttons automatically show a loading indicator while the action is in progress, and also provide error handling.

## Seamless Integration and Theming

One of the main goals of flutter_async is to provide a clean and seamless integration with existing Flutter widgets. The package is designed to be as "native" as possible, following closely Flutter's own conventions and practices.

When using flutter_async, all theme configurations from widgets are inherited from `ThemeData` as expected, and the package remains loyal to the original button themes. This loyalty to native design means you can easily add or remove flutter_async from your project with **no impact** on theming and styling.

## AsyncBuilder

AsyncBuilder is a powerful widget that simplifies handling of Future and Stream objects in Flutter.

Here are the properties of AsyncBuilder:

```dart
  /// The initial data to pass to the [builder].
  final T? initial;

  /// The bool [listenables] to listen and animate to external loading states.
  final List<ValueListenable<bool>> listenables;

  /// The [Future] to load [builder] with. When set, [stream] must be null.
  final Future<T> Function()? future;

  /// The [Stream] to load [builder] with. When set, [future] must be null.
  final Stream<T> Function()? stream;

  /// The interval to auto reload the [future]/[stream].
  final Duration? interval;

  /// The number of times to retry the [future]/[stream] on error.
  final int retry;

  /// The widget to build when [future]/[stream].onError is called.
  final Widget Function(AsyncController<T> controller)? error;

  /// The widget when [future]/[stream] has not completed the first time.
  final Widget? loader;

  /// The widget when [future]/[stream] has completed at least once.
  final Widget? reloader;

  /// The widget when [future]/[stream] has [T] data.
  final Widget Function(T data) builder;

  /// The [AsyncController] to use.
  final AsyncController<T>? controller;
```

## AsyncController

```dart
  /// Reloads the async [Function].
  void reload([ActionType action = ActionType.primary]);

  /// Whete this controller is attached to an async widget.
  bool get isAttached;

  /// The [Future] or [Stream] error.
  Object? get error;

  /// The [Future] or [Stream] stack trace.
  StackTrace? get stackTrace;

  /// A listenable that notifies when [isLoading] changes.
  ValueNotifier<bool> get loading;

  /// Whether the [Future] or [Stream] is loading.
  bool get isLoading;

  /// Whether the [Future] or [Stream] has an error.
  bool get hasError;
```

You can also use `AsyncController.future()` or `AsyncController.stream()` to unlock other
useful methods for `AsyncBuilder`.

For future:

```dart
  T? get data;
  bool get hasData;
  bool get isReloading;
```

For stream:

```dart
  void pause();
  void resume();
  void cancel();
  bool get isPaused;
  T? get data;
  bool get hasData;
  bool get isReloading;
```

If just need a simple `reload()` api for activating your buttons programatically, feel
free to use just the `AsyncController` base api. All async widgets are compatible with it.

## AsyncButton

AsyncButton is a set of widgets that are useful when the button triggers asynchronous actions, such as network requests. They automatically handle loading and error states. They come in four variants: AsyncElevatedButton, AsyncFilledButton, AsyncTextButton, and AsyncOutlinedButton.

Here are the properties of AsyncButton:

```dart
  /// The configs of [AsyncButton]. Prefer setting AsyncButton.setConfig().
  final AsyncButtonConfig? config;

  /// The controller of the button.
  final AsyncController? controller;

   /// The bool [listenables] to listen and animate to external loading states.
  final List<ValueListenable<bool>> listenables;
```

## Usage

Simply put Async in front of your Button.

```dart
  AsyncElevatedButton(
    onPressed: onHello,
    child: const Text('AsyncElevatedButton'),
  ),
```

Or use the AsyncButtonExtension:

```dart
  ElevatedButton(
    onPressed: onHello,
    child: const Text('ElevatedButton'),
  ).async(),
```

## Settings Global Config

Use the static functions to set it wherever you want.

```dart
    // You can set the default config of all AsyncButton's.
    AsyncButton.setConfig(const AsyncButtonConfig());

    // Or you can set the config of a specific AsyncButton.
    AsyncElevatedButton.setConfig(const AsyncButtonConfig());
    AsyncOutlinedButton.setConfig(const AsyncButtonConfig());
    AsyncFilledButton.setConfig(const AsyncButtonConfig());
    AsyncTextButton.setConfig(const AsyncButtonConfig());
```

### AsyncButtonConfig Properties

```dart
  /// Whether or not this button should keep its size when animating.
  final bool keepSize;

  /// The configuration for [AnimatedSize]. If null, sizing animation is ignored.
  final AnimatedSizeConfig? animatedSize;

  /// The duration to show error widget.
  final Duration errorDuration;

  /// The duration between styles animations.
  final Duration styleDuration;

  /// The curve to use on styles animations.
  final Curve styleCurve;

  /// The widget to show on loading.
  final Widget Function(AsyncButtonState state) loader;

  /// The widget to show on error.
  final Widget Function(AsyncButtonState state) error;

  /// The style to apply on loading.
  final ButtonStyle Function(AsyncButtonState state) loadingStyle;

  /// The style to apply on error.
  final ButtonStyle Function(AsyncButtonState state) errorStyle;
```

## Future Plans and Development

This package is currently a work in progress and we have exciting updates planned for the future. We are constantly working on improving and expanding the capabilities of our Async Widgets. As part of our roadmap, we're looking to introduce a variety of new widgets that will provide even more flexibility and functionality.

Your feedback is invaluable to us and we encourage you to contribute by suggesting new features, improvements and reporting bugs. We're also open to contributions from the open-source community.

Stay tuned for future updates and happy coding!
