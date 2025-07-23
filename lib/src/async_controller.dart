// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';

// import '../async_o_loader.dart';
// import 'async_controller_impl.dart';
// import 'widgets/async_state.dart';

// abstract class AsyncController<T> {
//   /// The [AsyncController] for any [AsyncWidget].
//   factory AsyncController() => AsyncControllerImpl();

//   /// The [AsyncFutureController] for [AsyncBuilder.getFuture].
//   static AsyncFutureController<T> future<T>() => AsyncBuilderControllerImpl();

//   /// The [AsyncStreamController] for [AsyncBuilder.getStream].
//   static AsyncStreamController<T> stream<T>() => AsyncBuilderControllerImpl();

//   /// The [AsyncButtonController] for [AsyncButton].
//   static AsyncButtonController<T> button<T>() => AsyncButtonControllerImpl();

//   /// A listenable that notifies when [isLoading] changes.
//   ValueNotifier<bool> get loading;

//   /// Whether the [AsyncWidget] is in loading state.
//   bool get isLoading;

//   /// The [AsyncWidget] async function error.
//   Object? get error;

//   /// The [Future] or [Stream] stack trace.
//   StackTrace? get stackTrace;

//   /// Whether the [AsyncWidget] async function has error.
//   bool get hasError;

//   /// Reloads the [AsyncWidget] primary function programmatically.
//   ///
//   /// Which is:
//   ///
//   /// - [AsyncBuilder.getFuture] or [AsyncBuilder.getStream]
//   /// - [AsyncButton.press]
//   ///
//   /// For a more granular control, use:
//   ///
//   /// - [AsyncFutureController] or simply [AsyncController.future]
//   /// - [AsyncStreamController] or simply [AsyncController.stream]
//   /// - [AsyncButtonController] or simply [AsyncController.button]
//   FutureOr<void> reload();
// }

// abstract class AsyncButtonController<T> extends AsyncController<T> {
//   factory AsyncButtonController() => AsyncButtonControllerImpl();

//   bool get isElevatedButton;
//   bool get isTextButton;
//   bool get isOutlinedButton;
//   bool get isFilledButton;

//   Size get size;

//   /// Performs [AsyncButton.press]. Use [press] instead.
//   @override
//   @Deprecated('Use .press() instead.')
//   FutureOr<void> reload();

//   /// Performs [AsyncButton.press].
//   FutureOr<void> press();

//   /// Performs [AsyncButton.longPress].
//   FutureOr<void> longPress();

//   /// Performs [AsyncButton.hover].
//   // FutureOr<void> hover(bool isHovering);
// }

// abstract class AsyncFutureController<T> extends AsyncController<T> {
//   factory AsyncFutureController() => AsyncBuilderControllerImpl();

//   /// The [Future] data.
//   T? get data;

//   /// Whether the [Future] has data.
//   bool get hasData;

//   /// Whether the [Future] is reloading.
//   bool get isReloading;
// }

// abstract class AsyncStreamController<T> extends AsyncController<T> {
//   factory AsyncStreamController() => AsyncBuilderControllerImpl();

//   /// Pause the [StreamSubscription].
//   void pause([Future<void>? resumeSignal]);

//   /// Resume the [StreamSubscription].
//   void resume();

//   /// Cancel the [StreamSubscription].
//   FutureOr<void> cancel();

//   /// Whether the [StreamSubscription] is paused.
//   bool get isPaused;

//   /// The [Stream] data.
//   T? get data;

//   /// Whether the [Stream] has data.
//   bool get hasData;

//   /// Whether the [Stream] is resumed with data.
//   bool get isReloading;
// }

// extension AsyncControllerExtension<T> on AsyncController<T> {
//   /// The message in [Error], [Exception] or [Object.toString].
//   String get errorMessage {
//     try {
//       // ignore: avoid_dynamic_calls
//       return (error as dynamic).message as String;
//     } catch (_) {
//       return '$error';
//     }
//   }
// }
