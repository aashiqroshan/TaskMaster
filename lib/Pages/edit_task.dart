import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/models/model.dart';

class EditTaskScreen extends StatefulWidget {
  final ToDo task;
  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late Prioritys selectedPriority;
  late DateTime selectedDueDate;
  DateTime? selectRemainder;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedPriority = widget.task.priority;
    selectedDueDate = widget.task.dueDate;
    selectRemainder = widget.task.reminder;
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

  Future<void> _selectRemainder(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: selectedDueDate);
    if (pickedDate != null) {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        setState(() {
          selectRemainder = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
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
            DropdownButton<Prioritys>(
              value: selectedPriority,
              items: Prioritys.values.map(
                (Prioritys priority) {
                  return DropdownMenuItem<Prioritys>(
                      value: priority,
                      child: Text(priority.toString().split('.').last));
                },
              ).toList(),
              onChanged: (Prioritys? newValue) {
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
            Text(
              selectRemainder != null
                  ? 'Reminding on : ${DateFormat('dd/MM/yyyy HH:mm').format(selectRemainder!)}'
                  : 'Select Reminder  :',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton.icon(
                onPressed: () => _selectRemainder(context),
                icon: const Icon(Icons.alarm_add),
                label: const Text('Set remainder')),
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
