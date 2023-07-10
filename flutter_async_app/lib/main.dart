import 'package:flutter/material.dart';

import 'package:flutter_async/flutter_async.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AsyncElevatedButton(
            onPressed: () {
              print('Hello World!');
            },
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
