import 'package:flutter/material.dart';
import 'package:flutter_async/src/widgets/async_builder/async_builder.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: MyWidget())));

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  Future<List<String>> getNames() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      'async',
      'tasks',
      'with',
      'ease',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.function(
        getFuture: getNames,
        builder: (context, data) {
          return const Placeholder();
        });
  }
}
