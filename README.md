<p align="center">
	<a href="https://pub.dartlang.org/packages/unwrapper"><img src="https://img.shields.io/pub/v/unwrapper?color=blue" alt="Pub dev"></a>
	<a href="https://github.com/majlindavdylaj/unwrapper/actions"><img src="https://github.com/majlindavdylaj/unwrapper/workflows/Build/badge.svg" alt="Build Status"></a>
</p>


# 🧩 Unwrapper

**Unwrapper** is a lightweight and flexible Flutter widget that lets you **unwrap** a parent widget and render one of its children directly — useful for dynamically skipping layout wrappers like `Container`, `Padding`, or custom widgets.

---

##  Features

-  Skip rendering the outer widget and show only its inner child or a specific child.
-  Custom unwrapping logic via a `resolver` callback.
-  Select a child by index when the widget has multiple `children`.
-  Optionally wrap the unwrapped widget using a `wrapperBuilder`.
-  Fallback widget if unwrapping fails.
-  Clean, declarative, and reusable API.

---

##  Getting Started

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  unwrapper: latest_version
```

Then install it:

```bash
flutter pub get
```

---

## Basic Usage

```dart
import 'package:unwrapper/unwrapper.dart';

Unwrapper(
  unwrap: true,
  child: Container(
    child: Text('Hello World'),
  ),
);
```

This renders just the `Text('Hello World')`, skipping the `Container`.

---

## Parameters

| Parameter         | Type                                       | Description |
|------------------|--------------------------------------------|-------------|
| `child`           | `Widget`                                   | The widget to potentially unwrap. *(Required)* |
| `unwrap`          | `bool`                                     | Whether to unwrap or render the widget as-is. *(Default: true)* |
| `childrenIndex`   | `int`                                      | Index to use if `child` has a `children` list. *(Default: 0)* |
| `fallback`        | `Widget`                                   | Fallback widget if unwrapping fails. *(Default: SizedBox.shrink())* |
| `wrapperBuilder`  | `Widget Function(Widget unwrapped)`        | Optional builder to wrap the unwrapped widget. |
| `resolver`        | `Widget? Function(Widget wrapper)`         | Custom logic to determine what to unwrap. |

---

##  Example with `childrenIndex`

```dart
Unwrapper(
  unwrap: true,
  childrenIndex: 1,
  child: Column(
    children: [
      Text('Header'),
      Text('Main Content'),
    ],
  ),
);
```

This unwraps and renders only the second child (`Text('Main Content')`).

---

## Example with `resolver` (Custom Widget)

You can define your own custom wrapper widget and use a `resolver` to unwrap it:

```dart
/// A custom wrapper widget with a `customChild` property.
class MyWrapper extends StatelessWidget {
  final Widget customChild;

  const MyWrapper({super.key, required this.customChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all()),
      child: customChild,
    );
  }
}

// Usage with Unwrapper
Unwrapper(
  unwrap: true,
  resolver: (widget) {
    if (widget is MyWrapper) {
      return widget.customChild;
    }
    return null;
  },
  child: MyWrapper(
    customChild: Text('Unwrapped from custom widget'),
  ),
);
```

This unwraps the `MyWrapper` and renders only the `Text` widget.

---

## Example Project

For a complete example, check out the [example folder](https://github.com/majlindavdylaj/unwrapper/tree/main/example) in the repository.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contributing

We welcome contributions! Feel free to submit issues or pull requests to improve this package.

---

Happy coding with **Unwrapper**! 
