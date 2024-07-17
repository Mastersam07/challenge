import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'outlined_input_border.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.labelText,
    this.label,
    this.initialValue,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.inputFormatters,
    this.keyboardType,
    this.autofillHints,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.controller,
  });

  final String? labelText;
  final Widget? label;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _controller.addListener(() {
      setState(() {});
    });

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  String? _validate(String? value) {
    final result = widget.validator?.call(value);

    bool newHasError = result != null;
    if (newHasError != _hasError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _hasError = newHasError;
        });
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? suffixIcon = _hasError
        ? const Icon(Icons.warning, color: Colors.red)
        : _controller.text.isNotEmpty && _focusNode.hasFocus
            ? Transform(
                transform: Matrix4.translationValues(0, 8, 0),
                child: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call("");
                  },
                ),
              )
            : null;

    return TextFormField(
      key: _key,
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      validator: _validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enabled,
      textCapitalization: widget.textCapitalization,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.05),
        border: OutlinedInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        focusedBorder: !widget.readOnly
            ? null
            : OutlinedInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 2,
                ),
              ),
        labelText: widget.labelText,
        label: widget.label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
        floatingLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        errorStyle: const TextStyle(fontSize: 14, color: Colors.red),
        hintStyle:
            TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
        suffixIcon: suffixIcon,
        counter: const SizedBox.shrink(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
