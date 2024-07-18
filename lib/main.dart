import 'package:flutter/material.dart';
import 'package:benjamin/widget/custom_text_form_field.dart';
import 'package:benjamin/widget/custom_dropdown_form_field.dart';
import 'package:flutter/services.dart';
import 'package:us_states/us_states.dart';

import 'viewmodel/form_controller.dart';
import 'data/model/address.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  final FormController? formController;
  const MyHomePage({super.key, this.formController});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FormController _formController;

  @override
  void initState() {
    super.initState();
    _formController = widget.formController ?? FormController();
  }

  @override
  void dispose() {
    if (widget.formController == null) _formController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff002433),
          title: const Text("Benjamin", style: TextStyle(color: Colors.white)),
        ),
        body: Form(
          key: _formController.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Autocomplete<Address>(
                  displayStringForOption: (Address option) => option.street,
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      _formController.clearFormFields();
                      return const Iterable<Address>.empty();
                    }
                    final suggestions = await _formController
                        .filterSuggestions(textEditingValue.text);
                    return suggestions;
                  },
                  onSelected: (Address suggestion) {
                    _formController.selectAddress(suggestion);
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback __,
                  ) {
                    return CustomTextFormField(
                      controller: textEditingController,
                      labelText: "Street address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address cannot be empty";
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9\s]')),
                      ],
                      focusNode: focusNode,
                      onChanged: (value) {
                        _formController.onStreetChanged(value);
                        if (value.isEmpty) {
                          _formController.clearFormFields();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _formController.line2Controller,
                  readOnly: true,
                  enabled: false,
                  labelText: "Street address line 2",
                  // validator: (value) {
                  //   if (value == null || value.isEmpty == true) {
                  //     return "Street address line 2 cannot be empty";
                  //   }
                  //   return null;
                  // },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _formController.cityController,
                        labelText: "City",
                        readOnly: true,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return "City cannot be empty";
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _formController.zipController,
                        labelText: "Zip",
                        readOnly: true,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return "Zip cannot be empty";
                          }
                          if (value.length != 5 ||
                              !RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return "Enter a valid 5-digit zip code";
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                    valueListenable: _formController.selectedState,
                    builder: (context, selectedState, child) {
                      return CustomDropdownFormField(
                        enabled: false,
                        selectedValue: selectedState,
                        onSelected: (value) {
                          _formController.selectedState.value = value;
                        },
                        labelText: "State",
                        items: USStates.getAllNames(),
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return "State cannot be empty";
                          }
                          return null;
                        },
                      );
                    }),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: _formController.hasError,
                  builder: (context, hasError, child) {
                    if (hasError) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: _formController.errorMessage,
                        builder: (context, errorMessage, child) {
                          return Text(
                            errorMessage ?? '',
                            style: const TextStyle(color: Colors.red),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _formController.isSubmitting,
          builder: (context, isSubmitting, child) {
            return ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () => _formController.submitForm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff002433),
                elevation: 2,
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff002433)),
                    )
                  : const Text("Submit", style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}
