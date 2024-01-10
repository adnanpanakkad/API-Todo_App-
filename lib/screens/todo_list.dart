// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_/screens/add_list.dart';
import 'package:flutter_application_/services/todo_services.dart';
import 'package:flutter_application_/utils/snackbar_helpers.dart';
import 'package:flutter_application_/widget/todo_card.dart';

typedef DeleteByIdFunction = Future<void> Function(String id);

class TodolistPage extends StatefulWidget {
  const TodolistPage({Key? key}) : super(key: key);

  @override
  State<TodolistPage> createState() => _TodolistState();
}

class _TodolistState extends State<TodolistPage> {
  bool isloading = true;
  List<Map<String, dynamic>> items = [];
  DeleteByIdFunction? deleteById;

  @override
  void initState() {
    super.initState();
    deleteById = _deleteById;
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.grey,
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo item',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index];
                final id = item['_id'] as String;
                return TodoCard(
                  index: index,
                  item: item,
                  deleteById: deleteById!,
                  navigateToEditpage: navigateToEditpage,
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 80,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: navigateToAddpage,
          label: const Text('Add'),
        ),
      ),
    );
  }

  Future<void> navigateToAddpage() async {
    final route = MaterialPageRoute(builder: (context) => const AddlistPage());
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditpage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddlistPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> _deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: 'Unable to delete');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(response);
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isloading = false;
    });
  }
}
