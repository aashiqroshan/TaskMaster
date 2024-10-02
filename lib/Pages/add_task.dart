import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/model.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  Priority selectedPriority = Priority.normal;

  DateTime? selectedDueDate;

  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2060));
    if (pickedDate != null && pickedDate != selectedDueDate) {
      setState(() {
        selectedDueDate = pickedDate;
      });
    }
  }

  final List<DropdownMenuItem<Priority>> dropdownitems = Priority.values
      .map(
        (priority) => DropdownMenuItem(
            value: priority, child: Text(priorityToString(priority))),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(label: Text('Description')),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<Priority>(
                decoration: const InputDecoration(labelText: 'Priority Level'),
                value: selectedPriority,
                items: dropdownitems,
                onChanged: (value) => setState(() {
                  selectedPriority = value!;
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDueDate == null
                            ? 'Select Due Date'
                            // :
                            : 'Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDueDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () => selectDueDate(context),
                          child: const Text('Pick Date'))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    final todo = ToDo(
                        title: titleController.text,
                        completed: false,
                        priority: Priority.normal,
                        description: descriptionController.text,
                        dueDate: selectedDueDate!);
                    context.read<ToDoBloc>().add(CreateTask(todo));
                    Navigator.pop(context);
                  },
                  child: const Text('Add Task'))
            ],
          ),
        ),
      ),
    );
  }
}

String priorityToString(Priority priority) {
  switch (priority) {
    case Priority.normal:
      return 'Normal';
    case Priority.important:
      return 'Important';
    case Priority.veryImportant:
      return 'Very Important';
    default:
      return 'Normal';
  }
}
