import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  static const String _key = 'tasks';

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> insertTask(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();

    tasks.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
    });

    prefs.setString(_key, jsonEncode(tasks));
  }

  static Future<void> updateTask(int id, String title) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();

    final index = tasks.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      tasks[index]['title'] = title;
      prefs.setString(_key, jsonEncode(tasks));
    }
  }

  static Future<void> deleteTask(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();

    tasks.removeWhere((t) => t['id'] == id);
    prefs.setString(_key, jsonEncode(tasks));
  }
}
