import 'package:benjamin/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              labelText: "Street address",
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Address cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              labelText: "Street address line 2",
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: CustomTextFormField(
                  labelText: "City",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextFormField(
                  labelText: "Zip",
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Expanded(
              child: CustomTextFormField(
                labelText: "State",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff002433),
        title: const Text("Benjamin", style: TextStyle(color: Colors.white)),
      ),
      body: _buildForm(),
      floatingActionButton: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff002433), elevation: 2),
        child: const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
