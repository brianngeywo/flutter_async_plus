import 'dart:async';

import 'package:flutter/material.dart';

/// Flutter code sample for [SearchAnchor.bar].

void main() => runApp(const SearchBarApp());

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  Color? selectedColorSeed;
  List<ColorLabel> searchHistory = <ColorLabel>[];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map(
      (ColorLabel color) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(color.label),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = color.label;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
      ),
    );
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return ColorLabel.values
        .where((ColorLabel color) => color.label.contains(input))
        .map(
          (ColorLabel filteredColor) => ListTile(
            leading: CircleAvatar(backgroundColor: filteredColor.color),
            title: Text(filteredColor.label),
            trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = filteredColor.label;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
            ),
            onTap: () {
              controller.closeView(filteredColor.label);
              handleSelection(filteredColor);
            },
          ),
        );
  }

  void handleSelection(ColorLabel selectedColor) {
    setState(() {
      selectedColorSeed = selectedColor.color;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, selectedColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, colorSchemeSeed: selectedColorSeed);
    final ColorScheme colors = themeData.colorScheme;

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Bar Sample')),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SearchAnchor.bar(
                barHintText: 'Search colors',
                suggestionsBuilder: (context, controller) {
                  if (controller.text.isEmpty) {
                    if (searchHistory.isNotEmpty) {
                      return getHistoryList(controller);
                    }
                    return [
                      Center(
                          child: Text('No search history.',
                              style: TextStyle(color: colors.outline)))
                    ];
                  }
                  return getSuggestions(controller);
                },
              ),
              AsyncSearch(
                search: (query) async {
                  return ColorLabel.values
                      .where((ColorLabel color) => color.label.contains(query))
                      .toList();
                },
                builder: (context, controller, value) {
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: value.color),
                    title: Text(value.label),
                    onTap: () {
                      controller.closeView(value.label);
                      handleSelection(value);
                    },
                  );
                },
              ),
              DebouncedSearchBar<ColorLabel>(
                result: (result) => result.name,
                title: (result) => Text(result.name),
                leading: (result) =>
                    CircleAvatar(backgroundColor: result.color),
                search: (query) async {
                  return ColorLabel.values
                      .where((ColorLabel color) => color.label.contains(query));
                },
              ),
              cardSize,
              Card(color: colors.primary, child: cardSize),
              Card(color: colors.onPrimary, child: cardSize),
              Card(color: colors.primaryContainer, child: cardSize),
              Card(color: colors.onPrimaryContainer, child: cardSize),
              Card(color: colors.secondary, child: cardSize),
              Card(color: colors.onSecondary, child: cardSize),
            ],
          ),
        ),
      ),
    );
  }
}

class AsyncSearch<T> extends StatefulWidget {
  const AsyncSearch({
    super.key,
    this.debounce = const Duration(milliseconds: 900),
    required this.search,
    required this.builder,
  });
  final Duration debounce;
  final Future<List<T>> Function(String query) search;
  final Widget Function(
    BuildContext context,
    SearchController controller,
    T value,
  ) builder;

  @override
  State<AsyncSearch<T>> createState() => _AsyncSearchState<T>();
}

class _AsyncSearchState<T> extends State<AsyncSearch<T>> {
  Timer? timer;
  var results = <T>[];
  var completer = Completer<List<T>>();
  var loading = ValueNotifier(false);
  final controller = SearchController();

  void sendResults(List<T> results) {
    loading.value = false;

    completer.complete(results);
    completer = Completer<List<T>>();
  }

  void debounce(VoidCallback fn) {
    sendResults(results);

    timer?.cancel();
    timer = Timer(widget.debounce, fn);
    loading.value = true;
  }

  Future<void> search() async {
    results = await widget.search(controller.text);
    sendResults(results);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: controller,
      viewTrailing: [
        ListenableBuilder(
          listenable: Listenable.merge([loading, controller]),
          builder: (context, _) {
            return SizedBox.square(
              dimension: 40,
              child: switch (loading.value) {
                true => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                false when controller.text.isNotEmpty => IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.clear,
                  ),
                false => const SizedBox(),
              },
            );
          },
        )
      ],
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) {
          sendResults([]);
          return [];
        }

        debounce(search);

        return [
          for (final value in await completer.future)
            widget.builder(context, controller, value),
        ];
      },
    );
  }
}

SizedBox cardSize = const SizedBox(
  width: 80,
  height: 30,
);

enum ColorLabel {
  red('red', Colors.red),
  orange('orange', Colors.orange),
  yellow('yellow', Colors.yellow),
  green('green', Colors.green),
  blue('blue', Colors.blue),
  indigo('indigo', Colors.indigo),
  violet('violet', Color(0xFF8F00FF)),
  purple('purple', Colors.purple),
  pink('pink', Colors.pink),
  silver('silver', Color(0xFF808080)),
  gold('gold', Color(0xFFFFD700)),
  beige('beige', Color(0xFFF5F5DC)),
  brown('brown', Colors.brown),
  grey('grey', Colors.grey),
  black('black', Colors.black),
  white('white', Colors.white);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

/// This is a simplified version of debounced search based on the following example:
/// https://api.flutter.dev/flutter/material/SearchAnchor-class.html#material.SearchAnchor.4
typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      print(error); // Should be 'Debounce cancelled' when cancelled.
      return null;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(_duration, _onComplete);
  }

  late final Timer _timer;
  final Duration _duration = const Duration(milliseconds: 500);
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.complete();
  }
}

class DebouncedSearchBar<T> extends StatefulWidget {
  const DebouncedSearchBar({
    super.key,
    this.hintText,
    this.debounce = const Duration(milliseconds: 1200),
    required this.result,
    required this.title,
    required this.search,
    this.subtitle,
    this.leading,
    this.onResultSelected,
  });

  final String? hintText;
  final Duration debounce;
  final String Function(T result) result;
  final Widget Function(T result) title;
  final Widget Function(T result)? subtitle;
  final Widget Function(T result)? leading;
  final Future<Iterable<T>> Function(String query) search;
  final Function(T result)? onResultSelected;

  @override
  State<StatefulWidget> createState() => DebouncedSearchBarState<T>();
}

class DebouncedSearchBarState<T> extends State<DebouncedSearchBar<T>> {
  final _searchController = SearchController();
  late final _Debounceable<Iterable<T>?, String> _debouncedSearch;

  Future<Iterable<T>> _search(String query) async {
    print('Searching for: $query');
    if (query.isEmpty) {
      return <T>[];
    }

    try {
      final results = await widget.search(query);
      return results;
    } catch (error) {
      return <T>[];
    }
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<T>?, String>(_search);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: widget.hintText,
        );
      },
      suggestionsBuilder: (context, controller) async {
        final results = await _debouncedSearch(controller.text);
        if (results == null) return [];

        return [
          for (final result in results)
            ListTile(
              title: widget.title(result),
              subtitle: widget.subtitle?.call(result),
              leading: widget.leading?.call(result),
              onTap: () {
                widget.onResultSelected?.call(result);
                controller.closeView(widget.result(result));
              },
            ),
        ];
      },
    );
  }
}
