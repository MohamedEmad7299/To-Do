import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/l10n/app_localizations.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  Timer? _timer;
  int _secondsRemaining = 0;
  final int _totalSeconds = 30 * 60;
  bool _isFocusing = false;

  final List<int> _weeklyData = [0, 0, 0, 0, 0, 0, 0];
  int _todayFocusMinutes = 0;
  DateTime? _focusStartTime;

  static const platform = MethodChannel('com.todo.app/audio');

  final List<_AppUsageData> _appUsageData = [
    _AppUsageData('Instagram', 45, Colors.pink, Icons.camera_alt),
    _AppUsageData('Twitter', 30, Colors.blue, Icons.alternate_email),
    _AppUsageData('Facebook', 25, Colors.indigo, Icons.facebook),
    _AppUsageData('Telegram', 20, Colors.lightBlue, Icons.send),
    _AppUsageData('Gmail', 15, Colors.red, Icons.mail),
  ];

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadWeeklyData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();

    setState(() {
      for (int i = 0; i < 7; i++) {
        final key = 'focus_day_$i';
        _weeklyData[i] = prefs.getInt(key) ?? 0;
      }

      final todayIndex = today.weekday % 7;
      _todayFocusMinutes = _weeklyData[todayIndex];
    });
  }

  Future<void> _saveWeeklyData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayIndex = today.weekday % 7;

    _weeklyData[todayIndex] = _todayFocusMinutes;

    await prefs.setInt('focus_day_$todayIndex', _todayFocusMinutes);
  }

  Future<void> _setRingerMode(bool mute) async {
    try {
      await platform.invokeMethod('setRingerMode', {'mute': mute});
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mute
                  ? 'Focus mode started - Please mute your device manually'
                  : 'Focus mode ended',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _startFocusing() {

    setState(() {
      _isFocusing = true;
      _secondsRemaining = _totalSeconds;
      _focusStartTime = DateTime.now();
    });

    _setRingerMode(true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopFocusing();
      }
    });
  }

  void _stopFocusing() {

    _timer?.cancel();

    if (_focusStartTime != null) {
      final focusedMinutes = (_totalSeconds - _secondsRemaining) ~/ 60;
      _todayFocusMinutes += focusedMinutes;
      _saveWeeklyData();
    }

    _setRingerMode(false);

    setState(() {
      _isFocusing = false;
      _secondsRemaining = 0;
      _focusStartTime = null;

      final todayIndex = DateTime.now().weekday % 7;
      _weeklyData[todayIndex] = _todayFocusMinutes;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.focusMode,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildTimerCircle(context, l10n),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  l10n.focusModeDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              _buildFocusButton(context, l10n),
              const SizedBox(height: 32),

              _buildOverviewSection(context, l10n),
              const SizedBox(height: 24),

              _buildApplicationsSection(context, l10n),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCircle(BuildContext context, AppLocalizations l10n) {
    final progress = _isFocusing
        ? (_totalSeconds - _secondsRemaining) / _totalSeconds
        : 0.0;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 8,
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              _isFocusing ? _formatTime(_secondsRemaining) : _formatTime(_totalSeconds),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusButton(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: _isFocusing ? _stopFocusing : _startFocusing,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFocusing
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _isFocusing ? l10n.stopFocusing : l10n.startFocusing,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, AppLocalizations l10n) {

    const weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    final maxValue = _weeklyData.reduce((a, b) => a > b ? a : b).toDouble();
    final effectiveMax = maxValue > 0 ? maxValue : 60.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.overview,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.thisWeek,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final isToday = index == DateTime.now().weekday % 7;
              final barHeight = (_weeklyData[index] / effectiveMax) * 120;
              final displayHeight = barHeight > 0 ? barHeight : 4.0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_weeklyData[index] > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${_weeklyData[index]}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 8,
                        ),
                      ),
                    ),
                  Container(
                    width: 24,
                    height: displayHeight,
                    decoration: BoxDecoration(
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weekDays[index],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.applications,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.appsThatMayDistract,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_appUsageData.length, (index) {
          final app = _appUsageData[index];
          return _buildAppUsageItem(context, app, l10n);
        }),
      ],
    );
  }

  Widget _buildAppUsageItem(BuildContext context, _AppUsageData app, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: app.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              app.icon,
              color: app.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  l10n.commonDistraction,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppUsageData {
  final String name;
  final int minutes;
  final Color color;
  final IconData icon;

  _AppUsageData(this.name, this.minutes, this.color, this.icon);
}
