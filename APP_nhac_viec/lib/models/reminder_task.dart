enum ReminderMethod {
  ringtone,
  email,
  notification,
}

extension ReminderMethodLabel on ReminderMethod {
  String get vietnameseLabel {
    switch (this) {
      case ReminderMethod.ringtone:
        return 'Nhắc bằng chuông';
      case ReminderMethod.email:
        return 'Nhắc bằng email';
      case ReminderMethod.notification:
        return 'Nhắc bằng thông báo';
    }
  }
}

class ReminderTask {
  ReminderTask({
    required this.name,
    required this.scheduledAt,
    required this.location,
    required this.remindOneDayBefore,
    required this.method,
  });

  final String name;
  final DateTime scheduledAt;
  final String location;
  final bool remindOneDayBefore;
  final ReminderMethod method;

  String get dateLabel {
    final d = scheduledAt.day.toString().padLeft(2, '0');
    final m = scheduledAt.month.toString().padLeft(2, '0');
    return '$d/$m';
  }
}
