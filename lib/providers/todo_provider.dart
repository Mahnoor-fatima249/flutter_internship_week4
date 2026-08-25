import 'package:flutter/foundation.dart';

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TodoProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(Task(title: title.trim()));
    notifyListeners();
  }

  void editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    _tasks[index].title = newTitle.trim();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }
}
