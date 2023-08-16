import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

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
    return Async(
      init: () => Future.delayed(const Duration(seconds: 1)),
      loader: (context) => const Center(child: Text('loading')),
      config: AsyncConfig(
        textButton: AsyncButtonConfig(
          loader: (_) => const Text('loading'),
        ),
      ),
      child: AsyncBuilder(
          getFuture: getNames,
          builder: (context, names) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Text(names[index]);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    AsyncBuilder.of(context).reload();
                  },
                  child: const Text('reload'),
                )
              ],
            );
          }),
    );
  }
}
