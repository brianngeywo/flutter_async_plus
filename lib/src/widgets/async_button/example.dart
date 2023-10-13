import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';


void main() => runApp(
      const MaterialApp(home: Scaffold(body: MyWidget())),
    );

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // onPressed
    Future<void> onPressed() async {
      await Future.delayed(const Duration(seconds: 1));
      throw Exception('Error');
    }

    final loading1 = ValueNotifier(false);
    final loading2 = ValueNotifier(true);
    final message1 = ValueNotifier('');
    final message2 = ValueNotifier('');

    return Transform.scale(
      scale: 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AsyncElevatedButton(
              onPressed: onPressed,
              child: const Text('ElevatedButton'),
            ),
            AsyncElevatedButton(
              config: AsyncButtonConfig(
                loader: (_) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: const Text(
                      'state.loadingMessage',
                      // key: ValueKey(state.loadingMessage),
                    ),
                  );
                },
              ),
              listenables: [
                loading1,
                loading2,
              ],
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 900));
                message1.value = 'lets go';
                await Future.delayed(const Duration(milliseconds: 900));
                message2.value = 'yes';
                await Future.delayed(const Duration(milliseconds: 900));
                message1.value = 'boom';
                await Future.delayed(const Duration(milliseconds: 900));
                message2.value = 'lalala';
                await Future.delayed(const Duration(milliseconds: 900));
              },
              child: const Text('OutlinedButton'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('TextButton'),
            ).asAsync(
              config: AsyncButtonConfig(
                loader: (context) => const CircularProgressIndicator(),
              ),

            ),
            // AsyncFilledButton(
            //   onPressed: onPressed,
            //   child: const Text('FilledButton'),
            // ),
          ],
        ),
      ),
    );
  }
}
