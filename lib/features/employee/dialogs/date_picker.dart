import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/date_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/asset_graphic.dart';
import '../../../common/widgets/safe_padding.dart';
import '../../../constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/calendar/calendar_controller.dart';
import '../widgets/calendar/calendar_top_action_view.dart';
import '../widgets/calendar/calendar_widget.dart';
import '../widgets/toggle_button.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final DateTime? markedDate;
  final bool canClear;

  const DatePicker({
    required this.onDateSelected,
    this.startDate,
    this.selectedDate,
    this.canClear = false,
    this.markedDate,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<DatePicker> {
  late final CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController(initialDate: widget.selectedDate);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarTopActionView(
          controller: _calendarController,
          canClear: widget.canClear,
          startDate: widget.startDate,
          onDateMoved: (date) {
            _calendarController.moveToDate(date);
          },
        ),
        CalendarWidget(
          controller: _calendarController,
          selectedDate: widget.selectedDate,
          startDate: widget.startDate,
          onDateSelected: (date) {
            // _selectedDateChangeNotifier.value = date;
          },
          markedDate: widget.markedDate,
        ),
        _bottomActions(),
      ],
    );
  }

  Widget _bottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        children: [
          const Divider(height: 2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    AssetGraphic(path: Assets.icons.calendar, width: 20),
                    const SizedBox(width: 8),
                    ValueListenableBuilder(
                      valueListenable: _calendarController.selectedDateNotifier,
                      builder: (context, date, child) {
                        return Text(
                          date == null ? 'No Date' : DateTimeUtils.formatIsoDate(date.toIso8601String()),
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: AppButton.secondary(
                        compact: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Cancel',
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: AppButton.primary(
                        compact: true,
                        onPressed: () {
                          if (_calendarController.selectedDateNotifier.value != null) {
                            widget.onDateSelected.call(_calendarController.selectedDateNotifier.value!);
                          } else if (widget.markedDate != null) {
                            widget.onDateSelected.call(widget.markedDate!);
                          }
                          Navigator.of(context).pop();
                        },
                        text: 'Save',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SafePadding(),
        ],
      ),
    );
  }
}
