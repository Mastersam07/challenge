import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:benjamin/data/repository.dart';
import 'package:benjamin/viewmodel/form_controller.dart';
import 'package:benjamin/main.dart';
import 'package:benjamin/data/model/address.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late MockRepository mockRepository;
  late FormController formController;

  setUp(() {
    mockRepository = MockRepository();
    formController = FormController(repo: mockRepository);

    when(() => mockRepository.getSuggestions(any()))
        .thenAnswer((invocation) async {
      final query = invocation.positionalArguments.first as String;
      if (query == 'error') {
        throw Exception('Failed to fetch suggestions.');
      }
      return [
        Address(
            street: '123 Main St',
            line2: 'Apt 4B',
            city: 'Springfield',
            zip: '12345'),
        Address(
            street: '456 Elm St',
            line2: 'Suite 5',
            city: 'Metropolis',
            zip: '67890'),
      ];
    });

    when(() => mockRepository.submitForm(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    formController.dispose();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyHomePage(formController: formController),
      ),
    );
  }

  testWidgets('displays initial form', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Street address'), findsOneWidget);
    expect(find.text('Street address line 2'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
    expect(find.text('Zip'), findsOneWidget);
    expect(find.text('State'), findsOneWidget);
  });

  testWidgets('displays suggestions on typing in street address',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final streetField = find.byType(TextFormField).first;

    await tester.tap(streetField);
    await tester.pump();

    await tester.enterText(streetField, '1');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(streetField, '12');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(streetField, '123');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('123 Main St'), findsOneWidget);
  });

  testWidgets('clears other fields when street address is cleared',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final streetField = find.byType(TextFormField).first;

    await tester.enterText(streetField, '123');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('123 Main St'));
    await tester.pump();

    expect(find.text('Apt 4B'), findsOneWidget);
    expect(find.text('Springfield'), findsOneWidget);
    expect(find.text('12345'), findsOneWidget);

    await tester.enterText(streetField, '');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Apt 4B'), findsNothing);
    expect(find.text('Springfield'), findsNothing);
    expect(find.text('12345'), findsNothing);
  });

  testWidgets('shows error when street address is "error"',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final streetField = find.byType(TextFormField).first;

    await tester.enterText(streetField, 'error');
    await tester.pump(const Duration(milliseconds: 300));

    expect(
        find.text('Exception: Failed to fetch suggestions.'), findsOneWidget);
  });

  testWidgets('submits form successfully', (WidgetTester tester) async {
    await pumpApp(tester);

    final streetField = find.byType(TextFormField).first;

    await tester.enterText(streetField, '123');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('123 Main St'));
    await tester.pump();

    // Select the state from the dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Alaska').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(() => mockRepository.submitForm(any())).called(1);
    expect(find.text('Form submitted successfully!'), findsOneWidget);
  });

  testWidgets('shows error on form submission failure',
      (WidgetTester tester) async {
    when(() => mockRepository.submitForm(any()))
        .thenThrow(Exception('Failed to submit form.'));

    await pumpApp(tester);

    final streetField = find.byType(TextFormField).first;

    await tester.enterText(streetField, '123');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('123 Main St'));
    await tester.pump();

    // Select the state from the dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alaska').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    verify(() => mockRepository.submitForm(any())).called(1);
    expect(
        find.text('Failed to submit form: Exception: Failed to submit form.'),
        findsOneWidget);
  });
}
