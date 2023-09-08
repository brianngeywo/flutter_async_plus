import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ValueNotifier(false);

    final asc = AsyncController();

    Future<String> onHello() async {
      await Future.delayed(const Duration(seconds: 1));
      throw 'Hello World!';
    }

    Future<void> loadTheme() async {
      Theme;
      await Future.delayed(const Duration(milliseconds: 300));
    }

    Future<void> loadTranslation() async {
      await Future.delayed(const Duration(milliseconds: 600));
    }

    Future<void> loadStorage() async {
      await Future.delayed(const Duration(milliseconds: 900));
    }

    return Async(
      init: () => Future.wait([
        loadTheme(),
        loadTranslation(),
        loadStorage(),
        Future.delayed(const Duration(seconds: 1)),
      ]),
      loader: (_) => const Center(child: CircularProgressIndicator()),
      child: MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.grey[300],
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: onHello,
                  child: const Text('ElevatedButton'),
                ).async(),
                Builder(builder: (context) {
                  return AsyncBuilder(
                      // controller: asc,
                      listenables: [asc.loading],
                      getFuture: () async {
                        await Future.delayed(const Duration(seconds: 3));
                        // return 'Hello World!';
                        throw ErrorHint('Omg, an error!');
                      },
                      error: (context, e, s) {
                        return FilledButton(
                          onPressed: () async {
                            await Future.delayed(const Duration(seconds: 1));
                            throw ErrorHint('Omg, an error!');
                          },
                          child: const Text('reload'),
                        ).async(listenables: [state]);
                      },
                      reloader: (_) => const FilledBlur(),
                      builder: (_, data) {
                        return const Text('lalala');
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final controller = MyController();

class FilledBlur extends StatelessWidget {
  const FilledBlur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Container());
  }
}

class Formx extends StatelessWidget {
  const Formx({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Fieldx extends StatelessWidget {
  const Fieldx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ColumnWith(
      children: [
        Placeholder(),
      ],
    );
  }
}

class ColumnWith extends StatelessWidget {
  const ColumnWith({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyController {
  Stream<String> onHelloS() async* {
    var count = 0;
    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      yield 'Hello Worlud! ${count++}';
    }
  }

  Future<String> onHello() async {
    await Future.delayed(const Duration(seconds: 1));

    // AsyncBuilder.reload('button');

    return 'Hello World!';

    // throw Exception('Hello World! error');
  }
}
