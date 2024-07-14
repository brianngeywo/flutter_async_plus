import 'package:flutter/widgets.dart';

/// A [BuildContext] extension for [Element], [State] and [Widget] visits.
extension ContextElementExtension on BuildContext {
  /// Visits the [Element] tree below this [BuildContext].
  ///
  /// If [onElement], [onState] or [onWidget] returns true, the visit will stop.
  void visit({
    bool Function(Element element)? onElement,
    bool Function(Widget widget)? onWidget,
    bool Function(State state)? onState,
  }) {
    assert(
      onElement != null || onState != null || onWidget != null,
      'At least one visitor must be set.',
    );

    void visit(Element el) {
      if (onElement?.call(el) ?? false) return;
      if (onWidget?.call(el.widget) ?? false) return;
      if (el is StatefulElement && (onState?.call(el.state) ?? false)) return;

      el.visitChildren(visit);
    }

    visitChildElements(visit);
  }
}
