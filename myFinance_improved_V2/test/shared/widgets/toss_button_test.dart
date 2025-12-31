import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

void main() {
  group('TossButton', () {
    group('Primary Button', () {
      testWidgets('renders with correct text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Save',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Save',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(pressed, true);
      });

      testWidgets('shows loading indicator when isLoading is true',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Save',
                onPressed: () {},
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('disabled button does not trigger onPressed',
          (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Save',
                onPressed: () => pressed = true,
                isEnabled: false,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(pressed, false);
      });

      testWidgets('renders with leading icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Add',
                onPressed: () {},
                leadingIcon: const Icon(Icons.add),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Add'), findsOneWidget);
      });

      testWidgets('fullWidth button expands to full width', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: TossButton.primary(
                  text: 'Full Width',
                  onPressed: () {},
                  fullWidth: true,
                ),
              ),
            ),
          ),
        );

        // Find the SizedBox that wraps the button content
        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(TossButton),
            matching: find.byType(SizedBox).first,
          ),
        );
        expect(sizedBox.width, double.infinity);
      });
    });

    group('Secondary Button', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.secondary(
                text: 'Cancel',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.secondary(
                text: 'Cancel',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Cancel'));
        await tester.pump();

        expect(pressed, true);
      });
    });

    group('Outlined Button', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.outlined(
                text: 'Edit',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Edit'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.outlined(
                text: 'Edit',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Edit'));
        await tester.pump();

        expect(pressed, true);
      });
    });

    group('Outlined Gray Button', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.outlinedGray(
                text: 'Option',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Option'), findsOneWidget);
      });
    });

    group('Text Button', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.textButton(
                text: 'Learn more',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text('Learn more'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.textButton(
                text: 'Learn more',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Learn more'));
        await tester.pump();

        expect(pressed, true);
      });
    });

    group('Debouncing', () {
      testWidgets('prevents rapid double taps', (tester) async {
        var tapCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Tap',
                onPressed: () => tapCount++,
                debounceDurationMs: 300,
              ),
            ),
          ),
        );

        // Rapid taps
        await tester.tap(find.text('Tap'));
        await tester.tap(find.text('Tap'));
        await tester.pump();

        // Only first tap should register due to debouncing
        expect(tapCount, 1);

        // Wait for debounce to complete
        await tester.pump(const Duration(milliseconds: 350));

        // Now another tap should work
        await tester.tap(find.text('Tap'));
        await tester.pump();

        expect(tapCount, 2);
      });
    });

    group('Loading State', () {
      testWidgets('does not call onPressed when loading', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TossButton.primary(
                text: 'Save',
                onPressed: () => pressed = true,
                isLoading: true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TossButton));
        await tester.pump();

        expect(pressed, false);
      });
    });

    group('Button Variants', () {
      testWidgets('all variants are instantiable', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TossButton.primary(text: 'Primary', onPressed: () {}),
                  TossButton.secondary(text: 'Secondary', onPressed: () {}),
                  TossButton.outlined(text: 'Outlined', onPressed: () {}),
                  TossButton.outlinedGray(text: 'OutlinedGray', onPressed: () {}),
                  TossButton.textButton(text: 'TextButton', onPressed: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
        expect(find.text('Outlined'), findsOneWidget);
        expect(find.text('OutlinedGray'), findsOneWidget);
        expect(find.text('TextButton'), findsOneWidget);
      });
    });
  });
}
