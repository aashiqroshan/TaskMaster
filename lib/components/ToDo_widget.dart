import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/Pages/edit_task.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/models/model.dart';

class TodoWidget extends StatelessWidget {
  final ToDo task;
  const TodoWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color containerColor;
    String priorLevel;
    switch (task.priority) {
      case Prioritys.normal:
        containerColor = Colors.yellow;
        priorLevel = 'Normal';
        break;
      case Prioritys.important:
        containerColor = Colors.orange;
        priorLevel = 'Important';
        break;
      case Prioritys.veryImportant:
        containerColor = Colors.redAccent;
        priorLevel = 'Very Important';
        break;
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: containerColor, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(task.description),
                    ],
                  ),
                  const Spacer(),
                  Switch(
                    value: task.completed,
                    onChanged: (bool newValue) {
                      context
                          .read<ToDoBloc>()
                          .add(UpdateTaskCompletion(task, newValue));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Due : ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(task: task),
                            ));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        context.read<ToDoBloc>().add(DeleteTask(task));
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              Text(
                'Priority Level : $priorLevel',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
