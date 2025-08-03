import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

void main() {
  group('KeyboardSafe Padding Tests', () {
    testWidgets('adds keyboard padding when viewInsets.bottom is non-zero',
        (WidgetTester tester) async {
      const keyboardHeight = 300.0;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: keyboardHeight),
            ),
            child: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              padding: EdgeInsets.zero,
              child: Container(key: Key('child')),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      final paddingValue = padding.padding as EdgeInsets;

      expect(paddingValue.bottom, keyboardHeight);
    });

    testWidgets('no padding when viewInsets.bottom is zero',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.zero,
            ),
            child: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              padding: EdgeInsets.zero,
              child: Container(key: Key('child')),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      final paddingValue = padding.padding as EdgeInsets;

      expect(paddingValue.bottom, 0);
    });

    testWidgets('combines custom padding with keyboard padding',
        (WidgetTester tester) async {
      const keyboardHeight = 300.0;
      const customPadding = EdgeInsets.all(20.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: keyboardHeight),
            ),
            child: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              padding: customPadding,
              child: Container(key: Key('child')),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      final paddingValue = padding.padding as EdgeInsets;

      expect(paddingValue.top, customPadding.top);
      expect(paddingValue.left, customPadding.left);
      expect(paddingValue.right, customPadding.right);
      expect(paddingValue.bottom, keyboardHeight + customPadding.bottom);
    });

    testWidgets('handles different keyboard heights',
        (WidgetTester tester) async {
      final keyboardHeights = [100.0, 250.0, 400.0, 500.0];

      for (int i = 0; i < keyboardHeights.length; i++) {
        final height = keyboardHeights[i];

        await tester.pumpWidget(
          MaterialApp(
            key: Key('app_$i'), // Unique key to force rebuild
            home: MediaQuery(
              data: MediaQueryData(
                viewInsets: EdgeInsets.only(bottom: height),
              ),
              child: KeyboardSafe(
                scroll: false,
                autoScrollToFocused: false,
                padding: EdgeInsets.zero,
                child: Container(key: Key('child_$i')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle(); // Wait for any animations

        final padding = tester.widget<Padding>(find.byType(Padding));
        final paddingValue = padding.padding as EdgeInsets;

        expect(paddingValue.bottom, height,
            reason: 'Failed for keyboard height: $height');
      }
    });
  });

  group('KeyboardSafe Tap Dismiss Tests', () {
    testWidgets('dismisses keyboard on tap outside when enabled',
        (WidgetTester tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: true,
              dismissOnTapOutside: true,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  TextField(focusNode: focusNode),
                  const SizedBox(height: 600),
                ],
              ),
            ),
          ),
        ),
      );

      // Focus the text field
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, true);

      // Tap outside
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, false);
    });

    testWidgets('does NOT dismiss keyboard on tap outside when disabled',
        (WidgetTester tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: true,
              dismissOnTapOutside: false,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  TextField(focusNode: focusNode),
                  const SizedBox(height: 600),
                ],
              ),
            ),
          ),
        ),
      );

      // Focus the text field
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, true);

      // Tap outside
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Focus should remain
      expect(focusNode.hasFocus, true);
    });

    testWidgets('does NOT dismiss keyboard on tap inside input field',
        (WidgetTester tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: true,
              dismissOnTapOutside: true,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  TextField(
                    focusNode: focusNode,
                    key: const Key('textfield'),
                  ),
                  const SizedBox(height: 600),
                ],
              ),
            ),
          ),
        ),
      );

      // Focus the text field
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, true);

      // Tap on the text field itself
      await tester.tap(find.byKey(const Key('textfield')));
      await tester.pumpAndSettle();

      // Focus should remain
      expect(focusNode.hasFocus, true);
    });
  });

  group('KeyboardSafe Scroll Tests', () {
    testWidgets('creates scrollable widget when scroll is enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: true,
              child: Column(
                children: List.generate(
                  5, // Reduced number to avoid timer issues
                  (index) => SizedBox(
                    height: 100,
                    child: Text('Item $index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for any focus changes

      // Should find a scrollable widget
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('does NOT create scrollable widget when scroll is disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              child: Container(child: Text('No scroll')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should NOT find a scrollable widget
      expect(find.byType(SingleChildScrollView), findsNothing);
    });
  });

  group('KeyboardSafe Configuration Tests', () {
    testWidgets('uses default scroll physics when scroll is enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardSafe(
              scroll: true,
              child: SizedBox(height: 1000, child: Text('Test')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final scrollView = tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));

      // Should have some physics (default platform physics)
      expect(scrollView.physics, isA<ScrollPhysics>());
    });

    testWidgets('validates autoScrollToFocused requires scroll enabled',
        (tester) async {
      var didThrow = false;

      try {
        KeyboardSafe(
          scroll: false,
          autoScrollToFocused: true,
          child: Container(),
        );
      } catch (e) {
        didThrow = true;
      }

      expect(didThrow, isTrue);
    });

    testWidgets('allows autoScrollToFocused when scroll is enabled',
        (WidgetTester tester) async {
      expect(
        () => KeyboardSafe(
          scroll: true,
          autoScrollToFocused: true,
          child: Container(),
        ),
        returnsNormally,
      );
    });
  });

  group('KeyboardSafe Edge Cases', () {
    testWidgets('handles very large keyboard heights',
        (WidgetTester tester) async {
      const largeKeyboardHeight = 800.0;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: largeKeyboardHeight),
            ),
            child: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              padding: EdgeInsets.zero,
              child: Container(key: Key('child')),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      final paddingValue = padding.padding as EdgeInsets;

      expect(paddingValue.bottom, largeKeyboardHeight);
    });

    testWidgets('handles fractional keyboard heights',
        (WidgetTester tester) async {
      const fractionalHeight = 299.75;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: fractionalHeight),
            ),
            child: KeyboardSafe(
              scroll: false,
              autoScrollToFocused: false,
              padding: EdgeInsets.zero,
              child: Container(key: Key('child')),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      final paddingValue = padding.padding as EdgeInsets;

      expect(paddingValue.bottom, fractionalHeight);
    });

    testWidgets('maintains child widget integrity',
        (WidgetTester tester) async {
      const testKey = Key('test-child');

      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardSafe(
            scroll: false,
            autoScrollToFocused: false,
            child: Container(
              key: testKey,
              child: const Text('Child Content'),
            ),
          ),
        ),
      );

      // Child should be present and accessible
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Child Content'), findsOneWidget);
    });
  });
}
