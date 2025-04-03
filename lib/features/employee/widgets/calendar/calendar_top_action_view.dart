import 'package:flutter/cupertino.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../toggle_button.dart';
import 'calendar_controller.dart';

class CalendarTopActionView extends StatefulWidget {
  final Function(DateTime date)? onDateMoved;
  final bool canClear;
  final CalendarController controller;
  final DateTime? startDate;

  const CalendarTopActionView({
    required this.controller,
    this.startDate,
    this.onDateMoved,
    this.canClear = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _CalendarTopActionView();
  }
}

class _CalendarTopActionView extends State<CalendarTopActionView> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _updateSelectedToggle();
    widget.controller.selectedDateNotifier.addListener(_updateSelectedToggle);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canClear) {
      return _topActions();
    } else {
      return _topNoDateActions();
    }
  }

  Widget _topActions() {
    final DateTime now = DateTime.now();
    final DateTime nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    final DateTime nextTuesday = now.add(Duration(days: (9 - now.weekday) % 7));
    final DateTime afterOneWeek = now.add(const Duration(days: 7));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 0,
                  onChanged: (value) => _onTogglePressed(0, now),
                  text: 'Today',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 1,
                  onChanged: (value) => _onTogglePressed(1, nextMonday),
                  text: 'Next Monday',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 2,
                  onChanged: (value) => _onTogglePressed(2, nextTuesday),
                  text: 'Next Tuesday',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 3,
                  onChanged: (value) => _onTogglePressed(3, afterOneWeek),
                  text: 'After 1 week',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topNoDateActions() {
    final DateTime now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 0,
                  onChanged: (value) => _onTogglePressed(0, null),
                  text: 'No Date',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ToggleButton(
                  isSelected: _selectedIndex == 1,
                  onChanged: (value) => _onTogglePressed(1, now),
                  text: 'Today',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTogglePressed(int index, DateTime? targetDate) {
    //if tapping on same button, should not react
    if (_selectedIndex == index) return;

    //if the target date is less than the from date
    final DateTime? startDateWithoutTime =
        widget.startDate != null
            ? DateTime(widget.startDate!.year, widget.startDate!.month, widget.startDate!.day)
            : null;
    final bool isDisabled =
        startDateWithoutTime != null && targetDate != null && targetDate.isBefore(startDateWithoutTime);
    if (index == 1 && isDisabled && widget.canClear) {
      AppSnackBar.showOverlaySnackbar(context, 'Oops! To date must be less than from date');
      return;
    };

    widget.controller.selectedDateNotifier.value = targetDate;
    setState(() {
      _selectedIndex = index;
    });
    // widget.onDateMoved?.call(targetDate);
  }

  int? _getSelectedIndex(DateTime date) {
    final DateTime now = DateTime.now();

    if (widget.canClear) {
      if (_isSameDay(date, now)) return 1;
      return null;
    }

    final DateTime nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    final DateTime nextTuesday = now.add(Duration(days: (9 - now.weekday) % 7));
    final DateTime afterOneWeek = now.add(const Duration(days: 7));

    if (_isSameDay(date, now)) return 0;
    if (_isSameDay(date, nextMonday)) return 1;
    if (_isSameDay(date, nextTuesday)) return 2;
    if (_isSameDay(date, afterOneWeek)) return 3;

    return null; // No match
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _updateSelectedToggle() {
    final DateTime? selectedDate = widget.controller.selectedDateNotifier.value;
    if (selectedDate != null) {
      final int? newIndex = _getSelectedIndex(selectedDate);

      if (newIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    }
  }
}
