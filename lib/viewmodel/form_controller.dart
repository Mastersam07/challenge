import 'dart:async';

import 'package:flutter/material.dart';
import '../data/model/address.dart';
import '../data/repository.dart';

class FormController {
  FormController({Repository? repo}) {
    _repository = repo ?? Repository();
  }
  late final Repository _repository;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController streetController = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final ValueNotifier<String?> selectedState = ValueNotifier(null);

  final ValueNotifier<List<Address>> filteredSuggestions = ValueNotifier([]);
  final ValueNotifier<bool> isSubmitting = ValueNotifier(false);
  final ValueNotifier<bool> hasError = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Timer? _debounce;

  void onStreetChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      filterSuggestions(query);
    });
  }

  Future<List<Address>> filterSuggestions(String query) async {
    try {
      hasError.value = false;
      errorMessage.value = null;

      if (query.length >= 2) {
        final suggestions = await _repository.getSuggestions(query);
        filteredSuggestions.value = suggestions;
      } else {
        filteredSuggestions.value = [];
      }
    } catch (e) {
      filteredSuggestions.value = [];
      hasError.value = true;
      errorMessage.value = e.toString();
    }
    return filteredSuggestions.value;
  }

  Future<void> selectAddress(Address addressDetails) async {
    streetController.text = addressDetails.street;
    line2Controller.text = addressDetails.line2;
    cityController.text = addressDetails.city;
    zipController.text = addressDetails.zip;
    filteredSuggestions.value = [];
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isSubmitting.value = true;

      try {
        await _repository.submitForm({
          'street': streetController.text,
          'line2': line2Controller.text,
          'city': cityController.text,
          'zip': zipController.text,
          'state': selectedState.value,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit form: $e')),
          );
        }
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  void clearFormFields() {
    line2Controller.clear();
    cityController.clear();
    zipController.clear();
    filteredSuggestions.value = [];
  }

  void dispose() {
    streetController.dispose();
    line2Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    _debounce?.cancel();
  }
}
