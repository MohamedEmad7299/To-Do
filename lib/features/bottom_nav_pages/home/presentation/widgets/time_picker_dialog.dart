import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

import 'calendar_picker_dialog.dart';

class TimePickerDialog extends StatefulWidget {
  final TimeOfDay? initialTime;

  const TimePickerDialog({
    super.key,
    this.initialTime,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;

  final FixedExtentScrollController _hourController = FixedExtentScrollController();
  final FixedExtentScrollController _minuteController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    final now = widget.initialTime ?? TimeOfDay.now();
    _selectedHour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    _selectedMinute = now.minute;
    _isAM = now.period == DayPeriod.am;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hourController.jumpToItem(_selectedHour - 1);
      _minuteController.jumpToItem(_selectedMinute);
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF4C4C4C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chooseTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Picker
                _buildTimePicker(
                  controller: _hourController,
                  itemCount: 12,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedHour = index + 1;
                    });
                  },
                  itemBuilder: (index) => (index + 1).toString().padLeft(2, '0'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Minute Picker
                _buildTimePicker(
                  controller: _minuteController,
                  itemCount: 60,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMinute = index;
                    });
                  },
                  itemBuilder: (index) => index.toString().padLeft(2, '0'),
                ),
                const SizedBox(width: 16),
                // AM/PM Toggle
                Column(
                  children: [
                    _buildPeriodButton('AM', _isAM, () {
                      setState(() => _isAM = true);
                    }),
                    const SizedBox(height: 8),
                    _buildPeriodButton('PM', !_isAM, () {
                      setState(() => _isAM = false);
                    }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int hour24 = _selectedHour == 12 ? 0 : _selectedHour;
                    if (!_isAM) hour24 += 12;

                    final timeOfDay = TimeOfDay(
                      hour: hour24,
                      minute: _selectedMinute,
                    );
                    Navigator.pop(context, timeOfDay);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Function(int) onSelectedItemChanged,
    required String Function(int) itemBuilder,
  }) {
    return SizedBox(
      width: 60,
      height: 120,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= itemCount) return null;
            return Center(
              child: Text(
                itemBuilder(index),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Helper function to show the time picker
Future<TimeOfDay?> showTimePicker2(BuildContext context, {TimeOfDay? initialTime}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => TimePickerDialog(initialTime: initialTime),
  );
}

// Combined function to show calendar then time picker
Future<Map<String, dynamic>?> showDateTimePicker(BuildContext context, {DateTime? initialDate}) async {
  if (!context.mounted) return null;

  final selectedDate = await showDialog<DateTime>(
    context: context,
    builder: (context) => CalendarPickerDialog(initialDate: initialDate),
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return null;

  final selectedTime = await showDialog<TimeOfDay>(
    context: context,
    builder: (context) => TimePickerDialog(initialTime: TimeOfDay.now()),
  );

  if (selectedTime == null) return null;

  return {
    'date': selectedDate,
    'time': selectedTime,
  };
}