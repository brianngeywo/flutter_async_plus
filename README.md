# Flutter Async

Flutter Async enhances Flutter widgets with async capabilities.

## Setup

Simply add `asAsync`. This will automatically update it to handle loading & error states.

```dart
  ElevatedButton(
    onPressed: () async { // <- mark it 'async'
      await Future.delayed(const Duration(seconds: 1));
    }
    child: const Text('ElevatedButton'),
  ).asAsync(), // <- add 'asAsync'
```

### Supported widgets:

The following widgets and their variants are supported:

| Widget                     | Variants                          |
|----------------------------|-----------------------------------|
| `ElevatedButton`           | icon                              |
| `OutlinedButton`           | icon                              |
| `TextButton`               | icon                              |
| `FilledButton`             | icon, tonal, tonalIcon            |
| `FloatingActionButton`     | small, large, extended            |
| `IconButton`               | filled, filledTonal, outlined     |


## Future<T> extensions

You can also automatically handle async states of any `Future<T>`:

```dart
// shows loading indicator while loading, hides when completed.
final todos = await getTodos().showLoading();

// shows error message if it completes with an error.
final todos = await getTodos().showSnackBar();

// you can customize the error message or add a success message.
final todos = await getTodos().showSnackBar(
  errorMessage: 'Failed to load todos',
  successMessage: 'Todos loaded successfully',
);
```

> This is possible thanks to `Async.context`, which defaults to the root `NavigatorState.context` of the app. If needed, you can provide a custom context by calling `showSnackBar(context: myContext)`.

You can customize the default loading using `Async` widget with your `AsyncConfig`.

You can customize the [SnackBar] shown, using:
- `AsyncSnackBar.errorBuilder`
- `AsyncSnackBar.successBuilder`
- `AsyncSnackBar.animationStyle`

Tip: It's highly recommended to simply modify you [ThemeData.snackBarTheme] instead.

## AsyncBuilder

AsyncBuilder is a powerful widget that simplifies handling of Future and Stream objects in Flutter. You don't have to define any builder. flutter_async defaults them to the `AsyncConfig`.

Here are the properties of AsyncBuilder:

```dart
 AsyncBuilder(
   // snapshot: // <- to direcly resolve a snapshot
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

Use `function` constructor for handling async functions:

This is usefeul for simple usecases with contained state management. If you are handling state in a separate class, better keep using the default constructor of `AsyncBuilder`.

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

Use `paged` constructor for handling pagination:

```dart
AsyncBuilder.paged(
  future: (page) async {
    await Future.delayed(duration);
    return List.generate(10, (i) => 'Item ${page * 10 + i}');
  },
  builder: (context, controller, list) {
    return ListView.builder(
      controller: controller,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(list[index]));
      },
    );
  },
)
```

## Customization

- Optional, but you can use [Async] config scope. This allows you to configure or override the default behavior of flutter_async. Works the same way as [Theme] widget for theming.

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

## Future Plans and Development

This package is currently a work in progress and we have exciting updates planned for the future. We are constantly working on improving and expanding the capabilities of our Async Widgets. As part of our roadmap, we're looking to introduce a variety of new widgets that will provide even more flexibility and functionality.

Your feedback is invaluable to us and we encourage you to contribute by suggesting new features, improvements and reporting bugs. We're also open to contributions from the open-source community.

Stay tuned for future updates and happy coding!
