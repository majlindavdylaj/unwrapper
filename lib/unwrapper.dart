import 'package:flutter/widgets.dart';

/// A widget that unwraps (skips) a specific parent widget
/// and renders its inner child instead.
///
/// This widget attempts to access and render the inner child widget
/// of the provided [child], based on certain heuristics:
/// - If a [resolver] callback is provided, it tries to get a custom unwrap result.
/// - Otherwise, if the [child] has a `child` property, it returns that.
/// - Otherwise, if the [child] has a `children` property, it returns the child at [childrenIndex].
/// - If none of the above work, it returns the [fallback] widget.
///
/// If [unwrap] is false, the widget simply renders the [child] as is.
/// If [wrapperBuilder] is provided, it wraps the unwrapped widget with the result
/// of the builder function.
class Unwrapper extends StatelessWidget {
  /// The widget to unwrap.
  final Widget child;

  /// Whether to perform unwrapping.
  ///
  /// If false, [child] is rendered directly without unwrapping.
  final bool unwrap;

  /// The index of the child to select when unwrapping from
  /// a widget that has multiple children (e.g., [Column]).
  final int childrenIndex;

  /// Optional builder to wrap the unwrapped widget before rendering.
  ///
  /// If null, the unwrapped widget is rendered directly.
  final Widget Function(Widget unwrapped)? wrapperBuilder;

  /// Optional resolver callback to provide custom unwrapping logic.
  ///
  /// If this returns a non-null widget, it will be used instead of
  /// the default unwrapping logic.
  final Widget? Function(Widget wrapper)? resolver;

  /// The widget to render if unwrapping fails.
  ///
  /// Defaults to an empty [SizedBox].
  final Widget fallback;

  /// Creates an [Unwrapper].
  ///
  /// The [child] parameter is required.
  const Unwrapper({
    super.key,
    required this.child,
    this.unwrap = true,
    this.childrenIndex = 0,
    this.wrapperBuilder,
    this.resolver,
    this.fallback = const SizedBox.shrink(),
  });

  /// Attempts to unwrap the [child] widget according to the
  /// unwrapping heuristics and the optional [resolver].
  Widget _unwrap() {
    final dynamic any = child;

    // Use custom resolver first, if provided
    try {
      if (resolver != null) {
        final result = resolver!(any);
        if (result != null) {
          return result;
        }
      }
    } catch (_) {
      // Ignore errors from resolver
    }

    // Try to unwrap if 'child' property exists
    try {
      if (any.child != null) {
        return any.child;
      }
    } catch (e) {
      // Ignore errors if property doesn't exist or is inaccessible
    }

    // Try to unwrap if 'children' property exists and is long enough
    try {
      if (any.children != null && any.children.length > childrenIndex) {
        return any.children[childrenIndex];
      }
    } catch (e) {
      // Ignore errors if property doesn't exist or is inaccessible
    }

    // Return fallback widget if unwrapping fails
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    // If unwrapping is disabled, render child as-is
    if (!unwrap) return child;

    // Otherwise, unwrap and optionally wrap the result
    final Widget unwrapped = _unwrap();
    return wrapperBuilder?.call(unwrapped) ?? unwrapped;
  }
}
