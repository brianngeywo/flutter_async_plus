import 'package:flutter/widgets.dart';

///
extension BuildContextExtension on BuildContext {
  /// Visits the first [T] element found.
  ///
  /// If [last] is true, then it will return the last [Element] found.
  /// Visiting last is O(N), avoid using [last] = true.
  ///
  T? visitElement<T extends Element>({
    bool last = false,
    bool Function(T element)? filter,
  }) {
    T? found;

    void visit(Element element) {
      if (element is T && (filter?.call(element) ?? true)) {
        found = element;
        if (!last) return;
      }
      element.visitChildren(visit);
    }

    visitChildElements(visit);
    return found;
  }

  /// Visits the first [T] widget found.
  ///
  /// If [last] is true, then it will return the last [Widget] found.
  /// Visiting last is O(N), avoid using [last] = true.
  ///
  T? visitWidget<T extends Widget>({
    bool last = false,
    bool Function(T widget)? filter,
  }) {
    bool filterWidgetByT(Element e) =>
        e.widget is T && (filter?.call(e.widget as T) ?? true);

    return visitElement(last: last, filter: filterWidgetByT)?.widget as T?;
  }

  /// Visits the first [T] state found.
  ///
  /// If [last] is true, then it will return the last [State] found.
  /// Visiting last is O(N), avoid using [last] = true.
  ///
  T? visitState<T extends State>({
    bool last = false,
    bool Function(T state)? filter,
  }) {
    bool filterStateByT(StatefulElement e) =>
        e.state is T && (filter?.call(e.state as T) ?? true);

    return visitElement(last: last, filter: filterStateByT)?.state as T?;
  }
}
