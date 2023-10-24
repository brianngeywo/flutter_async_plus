import 'package:async_notifier/async_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_async/flutter_async.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void listener() => setState(() {});

  @override
  void initState() {
    super.initState();
    _notifier.addListener(listener);
  }

  final _notifier = AsyncNotifier.late<int>();

  void fetch() {
    _notifier.future = null;
    _notifier.future = Future.delayed(const Duration(seconds: 2), () {
      throw Exception('error');
      return 1;
    });
  }

  void stream() {
    _notifier.stream =
        Stream.fromIterable([0, 1, 2, 3, 4, 5]).asyncMap((i) async {
      await Future.delayed(const Duration(seconds: 1));
      if (i == 2 || i > 4) throw Exception('error');
      return i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncBuilders(
          future: _notifier.future,
          // stream: _notifier.stream,
          builder: (_, data) {
            return Text(data.toString());
          },
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_notifier.value == null) return;
                  _notifier.value = _notifier.value! - 1;
                },
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () {
                  if (_notifier.value == null) return;
                  _notifier.value = _notifier.value! + 1;
                },
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () => fetch(),
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () => stream(),
                icon: const Icon(Icons.stream),
              ),
            ],
          ),
        ));
  }
}

class AsyncBuilders<T> extends StatelessWidget {
  const AsyncBuilders(
      {super.key, required this.builder, this.future, this.stream});

  final Widget Function(BuildContext context, T data) builder;
  final Future<T>? future;
  final Stream<T>? stream;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NewAsyncBuilder(
        future: future,
        stream: stream,
        builder: builder,
      ),
    );
  }
}
