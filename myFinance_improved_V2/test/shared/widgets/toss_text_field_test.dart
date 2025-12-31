import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

void main() {
  group('TossTextField', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter email'), findsOneWidget);
    });

    testWidgets('shows required indicator (*) when isRequired is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
              isRequired: true,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('does not show required indicator when isRequired is false',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
              isRequired: false,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('*'), findsNothing);
    });

    testWidgets('controller updates text', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@email.com');
      expect(controller.text, 'test@email.com');
    });

    testWidgets('onChanged callback is called when text changes',
        (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'hello');
      expect(changedValue, 'hello');
    });

    testWidgets('validator shows error message', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TossTextField(
                label: 'Email',
                hintText: 'Enter email',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email is required' : null,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('disabled field does not accept input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Email',
              hintText: 'Enter email',
              controller: controller,
              enabled: false,
            ),
          ),
        ),
      );

      // Try to enter text in disabled field
      await tester.enterText(find.byType(TextFormField), 'test');

      // Controller should remain empty since field is disabled
      expect(controller.text, '');
    });

    testWidgets('renders with custom labelWidget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTextField(
              labelWidget: const Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 4),
                  Text('Custom Label'),
                ],
              ),
              hintText: 'Enter email',
            ),
          ),
        ),
      );

      expect(find.text('Custom Label'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('renders with suffixIcon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Password',
              hintText: 'Enter password',
              obscureText: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('multiline field has correct maxLines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Description',
              hintText: 'Enter description',
              maxLines: 5,
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textFormField.maxLines, 5);
    });

    testWidgets('obscureText hides password', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Password',
              hintText: 'Enter password',
              obscureText: true,
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textFormField.obscureText, true);
    });

    testWidgets('isImportant changes label font weight', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TossTextField(
              label: 'Important Field',
              hintText: 'Enter value',
              isImportant: true,
            ),
          ),
        ),
      );

      // Find the label Text widget
      final labelFinder = find.text('Important Field');
      expect(labelFinder, findsOneWidget);

      // Verify the label is rendered (detailed style check would require
      // accessing the Text widget's style property)
      final textWidget = tester.widget<Text>(labelFinder);
      expect(textWidget.style?.fontWeight, FontWeight.w700);
    });
  });
}
