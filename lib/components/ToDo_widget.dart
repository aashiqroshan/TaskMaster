import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/model.dart';

class TodoWidget extends StatelessWidget {
  final ToDo task;
  const TodoWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: task.priority == Priority.veryImportant
                  ? Colors.redAccent
                  : Colors.blueAccent,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(task.description),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Due : ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
