import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:benjamin/data/repository.dart';
import 'package:benjamin/data/model/address.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late Repository repository;

  setUp(() {
    repository = Repository();
  });

  test('getSuggestions returns a list of addresses for a valid query',
      () async {
    const query = '123';
    final suggestions = await repository.getSuggestions(query);

    expect(suggestions, isA<List<Address>>());
    expect(suggestions.length, greaterThan(0));
  });

  test('getSuggestions throws an exception for "error" query', () async {
    const query = 'error';

    expect(() async => await repository.getSuggestions(query), throwsException);
  });

  test('submitForm completes successfully for a valid address', () async {
    final address = {
      'street': '123 Main St',
      'line2': 'Apt 4B',
      'city': 'Springfield',
      'zip': '12345',
      'state': 'IL',
    };

    await repository.submitForm(address);
    // If no exception is thrown, the test will pass
  });

  test('submitForm throws an exception for an address with "error" street',
      () async {
    final address = {
      'street': 'error',
      'line2': 'Apt 4B',
      'city': 'Springfield',
      'zip': '12345',
      'state': 'IL',
    };

    expect(() async => await repository.submitForm(address), throwsException);
  });
}
