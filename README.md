[//]: # (# Flutter Async)

[//]: # ()
[//]: # (Flutter Async enhances Flutter widgets with async capabilities.)

[//]: # ()
[//]: # (## Setup)

[//]: # ()
[//]: # (Simply add `asAsync`. This will automatically update it to handle loading & error states.)

[//]: # ()
[//]: # (```dart)

[//]: # (  ElevatedButton&#40;)

[//]: # (    onPressed: &#40;&#41; async { // <- mark it 'async')

[//]: # (      await Future.delayed&#40;const Duration&#40;seconds: 1&#41;&#41;;)

[//]: # (    })

[//]: # (    child: const Text&#40;'ElevatedButton'&#41;,)

[//]: # (  &#41;.asAsync&#40;&#41;, // <- add 'asAsync')

[//]: # (```)

[//]: # ()
[//]: # (### Supported widgets:)

[//]: # ()
[//]: # (The following widgets and their variants are supported:)

[//]: # ()
[//]: # (| Widget                     | Variants                          |)

[//]: # (|----------------------------|-----------------------------------|)

[//]: # (| `ElevatedButton`           | icon                              |)

[//]: # (| `OutlinedButton`           | icon                              |)

[//]: # (| `TextButton`               | icon                              |)

[//]: # (| `FilledButton`             | icon, tonal, tonalIcon            |)

[//]: # (| `FloatingActionButton`     | small, large, extended            |)

[//]: # (| `IconButton`               | filled, filledTonal, outlined     |)

[//]: # ()
[//]: # ()
[//]: # (## Future<T> extensions)

[//]: # ()
[//]: # (You can also automatically handle async states of any `Future<T>`:)

[//]: # ()
[//]: # (```dart)

[//]: # (// shows loading indicator while loading, hides when completed.)

[//]: # (final todos = await getTodos&#40;&#41;.showLoading&#40;&#41;;)

[//]: # ()
[//]: # (// shows error message if it completes with an error.)

[//]: # (final todos = await getTodos&#40;&#41;.showSnackBar&#40;&#41;;)

[//]: # ()
[//]: # (// you can customize the error message or add a success message.)

[//]: # (final todos = await getTodos&#40;&#41;.showSnackBar&#40;)

[//]: # (  errorMessage: 'Failed to load todos',)

[//]: # (  successMessage: 'Todos loaded successfully',)

[//]: # (&#41;;)

[//]: # (```)

[//]: # ()
[//]: # (> This is possible thanks to `Async.context`, which defaults to the root `NavigatorState.context` of the app. If needed, you can provide a custom context by calling `showSnackBar&#40;context: myContext&#41;`.)

[//]: # ()
[//]: # (You can customize the default loading using `Async` widget with your `AsyncConfig`.)

[//]: # ()
[//]: # (You can customize the [SnackBar] shown, using:)

[//]: # (- `AsyncSnackBar.errorBuilder`)

[//]: # (- `AsyncSnackBar.successBuilder`)

[//]: # (- `AsyncSnackBar.animationStyle`)

[//]: # ()
[//]: # (Tip: It's highly recommended to simply modify you [ThemeData.snackBarTheme] instead.)

[//]: # ()
[//]: # (## AsyncBuilder)

[//]: # ()
[//]: # (AsyncBuilder is a powerful widget that simplifies handling of Future and Stream objects in Flutter. You don't have to define any builder. async_o_loader defaults them to the `AsyncConfig`.)

[//]: # ()
[//]: # (Here are the properties of AsyncBuilder:)

[//]: # ()
[//]: # (```dart)

[//]: # ( AsyncBuilder&#40;)

[//]: # (   // snapshot: // <- to direcly resolve a snapshot)

[//]: # (   future: myFuture, // or stream)

[//]: # (   noneBuilder: &#40;context&#41; {)

[//]: # (    // shown when operation is not yet started. Ex: future and stream are null)

[//]: # (    // or completed without any error or data. Ex: Stream.empty&#40;&#41;)

[//]: # (    return Text&#40;'none'&#41;;)

[//]: # (   })

[//]: # (   loadingBuilder: &#40;context&#41; {)

[//]: # (     return const CircularProgressIndicator&#40;&#41;; // defaults to AsyncIndicator&#40;&#41;)

[//]: # (   },)

[//]: # (   reloadingBuilder: &#40;context&#41; {)

[//]: # (    // overlayed when `isLoading` and also `hasData` or `hasError`)

[//]: # (    // you can skip this loader by setting `AsyncBuilder.skipReloading` to true.)

[//]: # (     return const Align&#40;alignment: Alignment.topCenter, child: LinearProgressIndicator&#40;&#41;&#41;;)

[//]: # (   },)

[//]: # (   errorBuilder: &#40;context, error, stackTrace&#41; {)

[//]: # (     return Text&#40;'$error'&#41;;)

[//]: # (   },)

[//]: # (   builder: &#40;context, data&#41; {)

[//]: # (     return Text&#40;'$data'&#41;;)

[//]: # (   },)

[//]: # ( &#41;,)

[//]: # (```)

[//]: # ()
[//]: # (Use `function` constructor for handling async functions:)

[//]: # ()
[//]: # (This is usefeul for simple usecases with contained state management. If you are handling state in a separate class, better keep using the default constructor of `AsyncBuilder`.)

[//]: # ()
[//]: # (```dart)

[//]: # ( AsyncBuilder.function&#40;)

[//]: # (   future: &#40;&#41; => myFutureFunction&#40;&#41;, // or stream)

[//]: # (   interval: Duration&#40;seconds: 5&#41;, // auto reload)

[//]: # (   builder: &#40;context, data&#41; {)

[//]: # (     return TextButton&#40;)

[//]: # (      child: Text&#40;'$data'&#41;)

[//]: # (      onPressed: &#40;&#41; => AsyncBuilder.of&#40;context&#41;.reload&#40;&#41;; // manual reload)

[//]: # (    &#41;;)

[//]: # (   },)

[//]: # ( &#41;,)

[//]: # (```)

[//]: # ()
[//]: # (Use `paged` constructor for handling pagination:)

[//]: # ()
[//]: # (```dart)

[//]: # (AsyncBuilder.paged&#40;)

[//]: # (  future: &#40;page&#41; async {)

[//]: # (    await Future.delayed&#40;duration&#41;;)

[//]: # (    return List.generate&#40;10, &#40;i&#41; => 'Item ${page * 10 + i}'&#41;;)

[//]: # (  },)

[//]: # (  builder: &#40;context, controller, list&#41; {)

[//]: # (    return ListView.builder&#40;)

[//]: # (      controller: controller,)

[//]: # (      itemCount: list.length,)

[//]: # (      itemBuilder: &#40;context, index&#41; {)

[//]: # (        return ListTile&#40;title: Text&#40;list[index]&#41;&#41;;)

[//]: # (      },)

[//]: # (    &#41;;)

[//]: # (  },)

[//]: # (&#41;)

[//]: # (```)

[//]: # ()
[//]: # (## Customization)

[//]: # ()
[//]: # (- Optional, but you can use [Async] config scope. This allows you to configure or override the default behavior of async_o_loader. Works the same way as [Theme] widget for theming.)

[//]: # ()
[//]: # (```dart)

[//]: # (    return Async&#40;)

[//]: # (      config: AsyncConfig&#40;)

[//]: # (        loadingBuilder: &#40;_&#41; => CircurlarProgressIndicator&#40;&#41;,)

[//]: # (        textButtonConfig: AsyncButtonConfig&#40;)

[//]: # (          loadingBuilder: &#40;_&#41; => const Text&#40;'loading'&#41;,)

[//]: # (        &#41;,)

[//]: # (      &#41;,)

[//]: # (      child: // your scope.)

[//]: # (    &#41;)

[//]: # (```)

[//]: # ()
[//]: # (## Future Plans and Development)

[//]: # ()
[//]: # (This package is currently a work in progress and we have exciting updates planned for the future. We are constantly working on improving and expanding the capabilities of our Async Widgets. As part of our roadmap, we're looking to introduce a variety of new widgets that will provide even more flexibility and functionality.)

[//]: # ()
[//]: # (Your feedback is invaluable to us and we encourage you to contribute by suggesting new features, improvements and reporting bugs. We're also open to contributions from the open-source community.)

[//]: # ()
[//]: # (Stay tuned for future updates and happy coding!)
