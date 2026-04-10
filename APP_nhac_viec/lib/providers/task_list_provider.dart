import 'package:flutter/foundation.dart';

import '../models/reminder_task.dart';

class TaskListProvider extends ChangeNotifier {
  final List<ReminderTask> _tasks = [
    ReminderTask(
      name: 'Bảo vệ bài tập lớn ứng dụng di động',
      scheduledAt: DateTime(2025, 12, 18, 9, 0),
      location: 'Trường',
      remindOneDayBefore: true,
      method: ReminderMethod.notification,
    ),
    ReminderTask(
      name: 'Đi chơi Noel',
      scheduledAt: DateTime(2025, 12, 24, 18, 0),
      location: 'Trung tâm thành phố',
      remindOneDayBefore: false,
      method: ReminderMethod.ringtone,
    ),
    ReminderTask(
      name: 'Đá bóng với lớp IT 3 ngày',
      scheduledAt: DateTime(2025, 10, 12, 16, 30),
      location: 'Sân bóng khu B',
      remindOneDayBefore: true,
      method: ReminderMethod.email,
    ),
  ];

  List<ReminderTask> get tasks => List.unmodifiable(_tasks);

  void addTask(ReminderTask task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void removeTask(ReminderTask task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
