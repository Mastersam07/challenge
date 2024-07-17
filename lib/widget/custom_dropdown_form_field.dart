import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  const CustomDropdownFormField({
    super.key,
    this.labelText,
    this.validator,
    this.items = const [],
    this.selectedValue,
    this.onSelected,
    this.enabled = true,
  });

  final String? labelText;
  final FormFieldValidator<String>? validator;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?)? onSelected;
  final bool enabled;

  @override
  State createState() => _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      decoration: InputDecoration(
        enabled: widget.enabled,
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 2,
          ),
        ),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onSelected?.call(value);
      },
      validator: widget.validator,
    );
  }
}
