# Flutter Async

Flutter Async transforms traditional Flutter widgets into their asynchronous counterparts, enabling seamless handling of async operations. By extending familiar widgets with async functionality, this package allows for the effortless execution of background tasks, data fetching, and more, while providing feedback through loaders and handling errors—all without compromising the responsiveness of your app's interface.

## Getting Started

- Optional, but you can add `Async` widget to the root of your app. This allows you to configure or override the default behavior of flutter_async. You can scope how many `Async` widgets you want.

Use async as scope to provide custom [AsyncConfig]:

```dart
    return Async(
      config: AsyncConfig(
        loadingBuilder: (_) => CircurlarProgressIndicator(),
        textButtonConfig: AsyncButtonConfig(
          loadingBuilder: (_) => const Text('loading'),
        ),
      ),
      child: // your scope.
    )
```

## AsyncIndicator

A smart `CircularProgressIndicator` that automatically chooses betweens primary, onPrimary and fallback theme colors based on the color below it. Additionally never distorts when sized, can be overlayed on other widgets and linear interpolates stroke width when scaled down.

```dart
  AsyncIndicator()
  // or call it through the extension method:
  CircularProgressIndicator().asAsync()
```

This is the default `Async.loadingBuilder` for flutter_async. You can use it just like any progress indicator:

```dart
Builder(
  builder: (context) {
    if (isLoading) return AsyncIndicator();
    return ...
  }
)
```

## AsyncBuilder

AsyncBuilder is a powerful widget that simplifies handling of Future and Stream objects in Flutter. You don't have to define any builder. flutter_async defaults them to the `AsyncConfig`.

Here are the properties of AsyncBuilder:

```dart
 AsyncBuilder(
   future: myFuture, // or stream
   noneBuilder: (context) {
    // shown when operation is not yet started. Ex: future and stream are null
    // or completed without any error or data. Ex: Stream.empty()
    return Text('none');
   }
   loadingBuilder: (context) {
     return const CircularProgressIndicator(); // defaults to AsyncIndicator()
   },
   reloadingBuilder: (context) {
    // overlayed when `isLoading` and also `hasData` or `hasError`
    // you can skip this loader by setting `AsyncBuilder.skipReloading` to true.
     return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator());
   },
   errorBuilder: (context, error, stackTrace) {
     return Text('$error');
   },
   builder: (context, data) {
     return Text('$data');
   },
 ),
```

Or unlock some extra superpowers with `function` constructor for handling async functions:

This is usefeul for simple usecases with contained state management. If you are handling state in a separate class, better keep using the default constructor of  `AsyncBuilder`.

```dart
 AsyncBuilder.function(
   future: () => myFutureFunction(), // or stream
   interval: Duration(seconds: 5), // auto reload
   builder: (context, data) {
     return TextButton(
      child: Text('$data')
      onPressed: () => AsyncBuilder.of(context).reload(); // manual reload
    );
   },
 ),
```

## AsyncButton

Simply put Async in front of your Button.

```dart
  AsyncElevatedButton(
    onPressed: onHello,
    child: const Text('AsyncElevatedButton'),
  ),
```

Or use the AsyncButtonExtension, works on any flutter's ButtonStyleButton:

```dart
  ElevatedButton(
    onPressed: onHello,
    child: const Text('ElevatedButton'),
  ).asAsync(),
```

Control them programatically with:

```dart
  AsyncButton.at(context).press();
  AsyncButton.at(context).longPress();
```

### AsyncButtonConfig Properties

```dart
  /// Whether to keep button height on state changes. Defaults to `true`.
  final bool? keepHeight;

  /// Whether to keep button width on state changes. Defaults to `false`.
  final bool? keepWidth;

  /// Whether this button should animate its size.
  final bool? animateSize;

  /// The configuration for [AnimatedSize].
  final AnimatedSizeConfig? animatedSizeConfig;

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
```

## Future Plans and Development

This package is currently a work in progress and we have exciting updates planned for the future. We are constantly working on improving and expanding the capabilities of our Async Widgets. As part of our roadmap, we're looking to introduce a variety of new widgets that will provide even more flexibility and functionality.

Your feedback is invaluable to us and we encourage you to contribute by suggesting new features, improvements and reporting bugs. We're also open to contributions from the open-source community.

Stay tuned for future updates and happy coding!
