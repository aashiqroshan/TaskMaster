import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/model.dart';

class EditTaskScreen extends StatefulWidget {
  final ToDo task;
  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late Priority selectedPriority;
  late DateTime selectedDueDate;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedPriority = widget.task.priority;
    selectedDueDate = widget.task.dueDate;
    super.initState();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: selectedDueDate);
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<Priority>(
              value: selectedPriority,
              items: Priority.values.map(
                (Priority priority) {
                  return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last));
                },
              ).toList(),
              onChanged: (Priority? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('Due Date:'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(selectedDueDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () => _selectDueDate(context),
                    icon: const Icon(Icons.calendar_today))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final updatedtasks = ToDo(
                      title: titleController.text,
                      description: descriptionController.text,
                      priority: selectedPriority,
                      completed: widget.task.completed,
                      dueDate: selectedDueDate);
                  context.read<ToDoBloc>().add(EditTask(updatedtasks));
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
