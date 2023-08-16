import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final button1 = AsyncController.future();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AsyncBuilder(
              controller: button1,
              getFuture: () {
                return Future.delayed(const Duration(seconds: 1), () => '');
              },
              builder: (context, data) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AsyncElevatedButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        button1.reload();
                      },
                      // controller: button1,
                      listenables: [
                        button1.loading,
                      ],
                      child: const Text('Hello World!'),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        throw Exception('Error 1');
                      },
                      child: const Text('Hello World!'),
                    ).async(
                      controller: button1,
                    ),
                    FilledButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        throw Exception('Error 2');

                      },
                      child: const Text('Hello World!'),
                    ).async(controller: button1, listenables: []),
                    TextButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        throw Exception('Error 3');

                      },
                      child: const Text('Hello World!'),
                    ).async(
                      controller: button1,
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
