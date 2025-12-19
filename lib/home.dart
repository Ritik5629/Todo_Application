import 'package:flutter/material.dart';
import 'package:todo_list_curd/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await DBHelper.getTasks();
    setState(() {});
  }

  void showTaskSheet({Map<String, dynamic>? task}) {
    taskController.text = task?['title'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task == null ? "Add Task" : "Edit Task",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: "Enter task",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (taskController.text.isEmpty) return;

                  if (task == null) {
                    await DBHelper.insertTask(taskController.text);
                  } else {
                    await DBHelper.updateTask(task['id'], taskController.text);
                  }

                  taskController.clear();
                  if (!mounted) return;
                  Navigator.pop(context);
                  loadTasks();
                },
                child: Text(task == null ? "ADD" : "UPDATE"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,

      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("My Tasks"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showTaskSheet(),
        child: const Icon(Icons.add),
      ),

      body: tasks.isEmpty
          ? const Center(
              child: Text("No tasks added", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          showTaskSheet(task: task);
                        } else {
                          await DBHelper.deleteTask(task['id']);
                          loadTasks();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text("Edit")),
                        PopupMenuItem(value: 'delete', child: Text("Delete")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
