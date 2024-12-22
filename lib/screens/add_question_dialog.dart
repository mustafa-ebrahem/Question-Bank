import 'package:flutter/material.dart';

class AddQuestionDialog extends StatefulWidget {
  final String subjectId;

  const AddQuestionDialog({super.key, required this.subjectId});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _correctOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Question'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _questionController,
                maxLength: 200,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'Enter your question here',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Question must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _correctOptionIndex,
                        onChanged: (value) {
                          setState(() {
                            _correctOptionIndex = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Option ${index + 1}',
                            hintText: 'Enter option ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Option cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final options = _optionControllers
                  .map((controller) => controller.text.trim())
                  .toList();
              
              Navigator.of(context).pop({
                'questionText': _questionController.text.trim(),
                'options': options,
                'correctOptionIndex': _correctOptionIndex,
              });
            }
          },
          child: const Text('Add Question'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
