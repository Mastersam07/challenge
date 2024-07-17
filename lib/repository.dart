import 'dart:async';

import 'data/model/address.dart';

class Repository {
  final List<Address> _addressSuggestions = [
    Address(
      street: '123 Main St',
      line2: 'Apt 4B',
      city: 'Springfield',
      zip: '12345',
    ),
    Address(
      street: '456 Elm St',
      line2: 'Suite 5',
      city: 'Metropolis',
      zip: '67890',
    ),
    Address(
      street: '789 Maple Ave',
      line2: '',
      city: 'Gotham',
      zip: '54321',
    ),
  ];

  Future<List<Address>> getSuggestions(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    if (query == 'error') {
      throw Exception('Failed to fetch suggestions.');
    }

    return _addressSuggestions
        .where((address) =>
            address.street.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> submitForm(Map address) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate error response
    if (address['street'] == 'error') {
      throw Exception('Failed to submit form.');
    }

    // Simulate success response
  }
}
