import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmaster/Pages/add_task.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/components/ToDo_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster'),
      ),
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (context, state) {
          if (state is ToDoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ToDoLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return TodoWidget(task: task);
              },
            );
          } else {
            return const Center(
              child: Text('No tasks available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
