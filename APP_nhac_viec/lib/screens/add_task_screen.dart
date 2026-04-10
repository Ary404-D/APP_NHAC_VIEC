import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/reminder_task.dart';
import '../providers/task_list_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _pickedDateTime;
  bool _remindDayBefore = true;
  ReminderMethod _method = ReminderMethod.notification;

  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initial = _pickedDateTime ?? now.add(const Duration(hours: 1));

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!mounted || time == null) return;

    setState(() {
      _pickedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên công việc')),
      );
      return;
    }
    if (_pickedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn thời gian')),
      );
      return;
    }

    final task = ReminderTask(
      name: name,
      scheduledAt: _pickedDateTime!,
      location: _locationController.text.trim(),
      remindOneDayBefore: _remindDayBefore,
      method: _method,
    );

    context.read<TaskListProvider>().addTask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _pickedDateTime != null
        ? _dateTimeFormat.format(_pickedDateTime!)
        : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm công việc'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tên công việc',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDateTime,
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Thời gian',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                timeText.isEmpty ? '  /  /      --:--' : timeText,
                style: TextStyle(
                  fontSize: 16,
                  color: timeText.isEmpty
                      ? Theme.of(context).hintColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Địa điểm',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nhắc việc trước 1 ngày',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    thumbColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.green;
                      }
                      return null;
                    }),
                    trackColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.green.withOpacity(0.45);
                      }
                      return null;
                    }),
                  ),
                ),
                child: Switch(
                  value: _remindDayBefore,
                  onChanged: (v) => setState(() => _remindDayBefore = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ReminderMethod>(
            value: _method,
            decoration: const InputDecoration(
              labelText: 'Cách nhắc',
              border: OutlineInputBorder(),
            ),
            items: ReminderMethod.values
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text(m.vietnameseLabel),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _method = v);
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Ghi lại công việc'),
            ),
          ),
        ],
      ),
    );
  }
}
