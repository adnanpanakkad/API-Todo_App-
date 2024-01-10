// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_/services/todo_services.dart';
import 'package:flutter_application_/utils/snackbar_helpers.dart';

class AddlistPage extends StatefulWidget {
  final Map? todo;
  const AddlistPage({super.key, this.todo});

  @override
  State<AddlistPage> createState() => _AddlistPageState();
}

class _AddlistPageState extends State<AddlistPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController(); // Corrected variable name
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) { // Corrected condition
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description; // Corrected variable name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController, // Corrected variable name
              decoration: const InputDecoration(
                hintText: 'Description', // Corrected spelling
              ),
              minLines: 5,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData, // Corrected function name
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updating success');
    } else {
      showErrorMessage(context, message: 'Updating failed');
    }
  }

  Future<void> submitData() async { // Corrected function name
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = ''; // Corrected variable name
      showSuccessMessage(context, message: 'Creation success'); // Corrected message
    } else {
      showErrorMessage(context, message: 'Creation failed'); // Corrected message
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false, // Corrected key naming
    };
  }
}
