import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: MyWidget())));

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return AsyncBuilder<int>.function(
      future: () => Future.delayed(const Duration(seconds: 3), () => 5),
      builder: (context, data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AsyncElevatedButton(
              key: const Key('first'),
              config: const AsyncButtonConfig(keepHeight: true
                  // loadingBuilder: (_) => const Text('Loading...'),
                  ),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 2));
                throw 'error';
              },
              child: const Text('data'),
            ),
            AsyncElevatedButton(
              config: AsyncButtonConfig(
                loadingBuilder: (_) => const Text('Loading...'),
              ),
              onPressed: () {
                AsyncBuilder.of(context).reload();
              },
              child: const Text('data'),
            ),
          ],
        );
      },
    );
  }
}
