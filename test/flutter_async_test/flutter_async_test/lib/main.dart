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

    // You can set the default config of all AsyncButton's.
    AsyncButton.setConfig(const AsyncButtonConfig());

    // Or you can set the config of a specific AsyncButton.
    AsyncElevatedButton.setConfig(const AsyncButtonConfig());
    AsyncOutlinedButton.setConfig(const AsyncButtonConfig());
    AsyncFilledButton.setConfig(const AsyncButtonConfig());
    AsyncTextButton.setConfig(const AsyncButtonConfig());

    return MaterialApp(
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
                    future: () async {
                      await Future.delayed(const Duration(seconds: 3));
                      // return 'Hello World!';
                      throw ErrorHint('Omg, an error!');
                    },
                    error: (controller) {
                      return FilledButton(
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          throw ErrorHint('Omg, an error!');
                        },
                        child: const Text('reload'),
                      ).async(listenables: [state]);
                    },
                    reloader: const FilledBlur(),
                    builder: (data) {
                      return const Text('lalala');
                    });
              }),
            ],
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
