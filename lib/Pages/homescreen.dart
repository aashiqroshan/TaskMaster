import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmaster/Pages/add_task.dart';
import 'package:taskmaster/bloc/to_do_bloc.dart';
import 'package:taskmaster/components/ToDo_widget.dart';
import 'package:taskmaster/models/model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final searchController = TextEditingController();
  SortOption? _selectedSortOption;
  List<ToDo> sortTasks(List<ToDo> tasks) {
    switch (_selectedSortOption) {
      case SortOption.dueDate:
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortOption.prioritys:
        tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortOption.nameOrder:
        tasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        break;
    }
    return tasks;
  }

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
            List<ToDo> filteredTasks = state.tasks.where(
              (task) {
                return task.title
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                    task.description
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
              },
            ).toList();
            List<ToDo> sortedTasks = sortTasks(filteredTasks);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              label: Text('search tasks'),
                              border: OutlineInputBorder()),
                          controller: searchController,
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      DropdownButton<SortOption>(
                        items: const [
                          DropdownMenuItem(
                              value: SortOption.dueDate,
                              child: Text('Sort by Date')),
                          DropdownMenuItem(
                              value: SortOption.prioritys,
                              child: Text('Sort by Priority')),
                          DropdownMenuItem(
                              value: SortOption.nameOrder,
                              child: Text('Sort by Name'))
                        ],
                        value: _selectedSortOption,
                        onChanged: (SortOption? newvalue) {
                          setState(() {
                            _selectedSortOption = newvalue;
                          });
                        },
                        isExpanded: false,
                        underline: Container(),
                        iconSize: 16,
                        hint: const Text('Sort'),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedTasks.length,
                    itemBuilder: (context, index) {
                      final task = sortedTasks[index];
                      return TodoWidget(task: task);
                    },
                  ),
                ),
              ],
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

enum SortOption { dueDate, prioritys, nameOrder }
