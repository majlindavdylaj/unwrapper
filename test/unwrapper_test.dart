import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unwrapper/unwrapper.dart';

void main() {
  // Test: When unwrap is false, the widget should render exactly the child passed in
  testWidgets('returns child directly when unwrap is false', (tester) async {
    final testChild = Text('Child');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: false, // Disable unwrapping
          child: testChild,
        ),
      ),
    );

    // Verify that the original child widget is present in the widget tree
    expect(find.byWidget(testChild), findsOneWidget);
  });

  // Test: When unwrap is true and child has a `child` property, unwrap returns that inner child
  testWidgets('unwraps child property', (tester) async {
    final innerChild = Text('Inner Child');

    // Container has a `child` property, so we wrap innerChild in it
    final wrapped = Container(child: innerChild);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: true, // Enable unwrapping
          child: wrapped,
        ),
      ),
    );

    // Verify that innerChild is present
    expect(find.byWidget(innerChild), findsOneWidget);

    // Verify that Container itself is NOT rendered (unwrapped)
    expect(find.byType(Container), findsNothing);
  });

  // Test: When unwrap is true and child has `children`, unwrap returns the child at childrenIndex
  testWidgets('unwraps children property using childrenIndex', (tester) async {
    final child0 = Text('First');
    final child1 = Text('Second');
    final child2 = Text('Third');

    // Column has a `children` property, so we wrap multiple Text widgets in it
    final wrapped = Column(children: [child0, child1, child2]);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: true,
          childrenIndex: 1, // We want to unwrap the second child (index 1)
          child: wrapped,
        ),
      ),
    );

    // Verify only the second child is rendered
    expect(find.byWidget(child1), findsOneWidget);

    // Verify the first and third children are NOT rendered
    expect(find.byWidget(child0), findsNothing);
    expect(find.byWidget(child2), findsNothing);

    // Verify Column itself is NOT rendered (unwrapped)
    expect(find.byType(Column), findsNothing);
  });

  // Test: When a resolver callback is provided, it is used to unwrap the widget
  testWidgets('uses resolver if provided and returns non-null', (tester) async {
    final customResolved = Text('Resolved Widget');
    final wrapped = SizedBox(child: Text('Inner'));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: true,
          // Custom resolver returns `customResolved` if widget is a SizedBox
          resolver: (widget) {
            if (widget is SizedBox) {
              return customResolved;
            }
            return null; // Otherwise fallback to default logic
          },
          child: wrapped,
        ),
      ),
    );

    // Verify the custom resolved widget is rendered
    expect(find.byWidget(customResolved), findsOneWidget);

    // Verify original SizedBox is NOT rendered (unwrapped)
    expect(find.byType(SizedBox), findsNothing);
  });

  // Test: wrapperBuilder wraps the unwrapped child widget with another widget
  testWidgets('applies wrapperBuilder on unwrapped widget', (tester) async {
    final innerChild = Text('Inner');

    final wrapped = Container(child: innerChild);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: true,
          // Wrap the unwrapped child in Padding with 8px padding
          wrapperBuilder: (child) =>
              Padding(padding: EdgeInsets.all(8), child: child),
          child: wrapped,
        ),
      ),
    );

    // Verify the inner child is still rendered
    expect(find.byWidget(innerChild), findsOneWidget);

    // Verify that the Padding widget is added by wrapperBuilder
    expect(find.byType(Padding), findsOneWidget);
  });

  // Test: When unwrapping fails, the fallback widget is rendered instead
  testWidgets('returns fallback widget if unwrap fails', (tester) async {
    final fallback = Text('Fallback');

    // A widget without child or children property (leaf widget)
    final leafWidget = Text('Leaf');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Unwrapper(
          unwrap: true,
          fallback: fallback, // Provide fallback widget
          child: leafWidget,
        ),
      ),
    );

    // Verify fallback is rendered
    expect(find.byWidget(fallback), findsOneWidget);

    // Verify original leaf widget is NOT rendered (unwrap failed)
    expect(find.byWidget(leafWidget), findsNothing);
  });
}
