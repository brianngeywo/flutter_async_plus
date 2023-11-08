import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            // surface: Colors.black,
            // onSurface: Colors.black,
            onPrimary: Colors.white,
            primary: Colors.black,
          ),
        ),
        home: const Scaffold(
          body: MyWidget(),
        ),
      ),
    );

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  static const duration = Duration(seconds: 1);

  Future<int> onPressed() async {
    await Future.delayed(duration);
    throw 'Some really long message error';
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AsyncBuilder(
          future: onPressed(), // or stream
          loadingBuilder: (context) {
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return Text(error.toString());
          },
          builder: (context, data) {
            return Text('$data');
          },
        ),
        AsyncElevatedButton(
          onPressed: onPressed,
          child: const Text('data'),
        ),
        AsyncTextButton(
          onPressed: onPressed,
          child: const Text('data'),
        ),
        AsyncOutlinedButton(
          onPressed: onPressed,
          child: const Text('data'),
        ),
        AsyncFilledButton(
          onPressed: onPressed,
          child: const Text('data'),
        ),
      ].map((e) => Expanded(child: Center(child: e))).toList(),
    );
  }
}
