import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/asset_graphic.dart';
import '../../../../constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import 'calendar_controller.dart';

class CalendarWidget extends StatefulWidget {
  final CalendarController controller;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final DateTime? markedDate;

  const CalendarWidget({
    required this.controller,
    required this.onDateSelected,
    this.startDate,
    this.selectedDate,
    this.markedDate,
    super.key,
  });

  @override
  State createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final PageController _pageController = PageController(initialPage: 1000);
  DateTime? _selectedDate;
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(1000);

  final int monthsOffset = 1000;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _pageController.addListener(() {
      _pageNotifier.value = (_pageController.page ?? monthsOffset).round();
    });
    _calculateTargetPageIndex(onPageLoad: true);
    widget.controller.selectedDateNotifier.addListener(_calculateTargetPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: AssetGraphic(path: Assets.icons.arrowLeftGrey, height: 24),
                onPressed: _onLeftArrowPressed,
              ),
              ValueListenableBuilder(
                valueListenable: _pageNotifier,
                builder: (context, page, child) {
                  final int pageIndex = page.round();
                  final DateTime pageMonth = DateTime(
                    DateTime.now().year,
                    DateTime.now().month + (pageIndex - monthsOffset),
                  );
                  return Container(
                    alignment: Alignment.center,
                    width: (kIsWeb ? 390 : MediaQuery.of(context).size.width) * 0.35,
                    child: Text(
                      DateFormat('MMMM yyyy').format(pageMonth), // Properly formatted date
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
              IconButton(
                icon: AssetGraphic(path: Assets.icons.arrowRightGrey, height: 24),
                onPressed: _onRightArrowPressed,
              ),
            ],
          ),
        ),
        // PageView for Month
        SizedBox(
          height: (7 * 44.0) + 4, //4 is to match the day labels bottom padding,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              final currentMonth = DateTime.now();
              final DateTime pageMonth = DateTime(currentMonth.year, currentMonth.month + (index - monthsOffset));
              return _MonthCalendarWidget(
                pageMonth: pageMonth,
                selectedDate: _selectedDate,
                startDate: widget.startDate,
                markedDate: widget.markedDate,
                onDateTap: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  widget.controller.onDateSelected(date);
                  // widget.onDateSelected(date);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void moveTo({required int days}) {
    setState(() {
      _selectedDate ??= DateTime.now();
      _selectedDate = _selectedDate!.add(Duration(days: days));
      widget.onDateSelected(_selectedDate!);
    });
  }

  void _onLeftArrowPressed() {
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onRightArrowPressed() {
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _calculateTargetPageIndex({bool onPageLoad = false}) async {
    _selectedDate = widget.controller.selectedDateNotifier.value;
    if (_selectedDate == null) { //no need to manually adjust the calender month view is selected date is null
      if (!onPageLoad) {
        setState(() {});
      }
      return;
    };
    final int currentYear = DateTime.now().year;
    final int currentMonth = DateTime.now().month;
    final int targetPageIndex =
        (_selectedDate!.year - currentYear) * 12 + (_selectedDate!.month - currentMonth) + monthsOffset;

    await Future.delayed(const Duration());
    if (_pageController.hasClients) {
      _pageNotifier.value = targetPageIndex;
      if (onPageLoad) {
        _pageController.jumpToPage(targetPageIndex);
      } else {
        await _pageController.animateToPage(
          targetPageIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    }
    if (!onPageLoad) {
      setState(() {});
    }
  }
}

class _MonthCalendarWidget extends StatelessWidget {
  final DateTime pageMonth;
  final DateTime? selectedDate;
  final DateTime? startDate;
  final DateTime? markedDate;
  final Function(DateTime) onDateTap;

  final dayLabels = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  const _MonthCalendarWidget({
    required this.pageMonth,
    required this.onDateTap,
    this.markedDate,
    this.startDate,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDays = DateTime(pageMonth.year, pageMonth.month + 1, 0).day; // Total days in month
    final int firstDayOffset = DateTime(pageMonth.year, pageMonth.month).weekday % 7; // first weekday offset
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 days in a week
            childAspectRatio: 1.2,
          ),
          itemCount: dayLabels.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              child: Text(dayLabels[index], style: const TextStyle(fontSize: 15)),
            );
          },
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 days in a week
            childAspectRatio: 1.3,
          ),
          itemCount: totalDays + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) {
              return Container(
                alignment: Alignment.center,
                child: const Text('', style: TextStyle(fontSize: 15, color: Colors.black)),
              ); // Empty cells before the 1st of the month
            }

            final int dayNumber = index - firstDayOffset + 1;
            final DateTime dayDate = DateTime(pageMonth.year, pageMonth.month, dayNumber);
            final DateTime? startDateWithoutTime =
                startDate != null ? DateTime(startDate!.year, startDate!.month, startDate!.day) : null;
            final bool isDisabled = startDateWithoutTime != null && dayDate.isBefore(startDateWithoutTime);
            final bool isSelected =
                selectedDate != null &&
                (selectedDate!.year == dayDate.year &&
                    selectedDate!.month == dayDate.month &&
                    selectedDate!.day == dayDate.day);
            final bool isToday =
                DateTime.now().year == dayDate.year &&
                DateTime.now().month == dayDate.month &&
                DateTime.now().day == dayDate.day;
            final bool isMarked =
                markedDate != null &&
                markedDate!.year == dayDate.year &&
                markedDate!.month == dayDate.month &&
                markedDate!.day == dayDate.day;

            return GestureDetector(
              onTap: isDisabled ? null : () => onDateTap(dayDate),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday ? Border.all(color: AppColors.primaryColor) : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        isDisabled
                            ? const Color(0xFFE5E5E5)
                            : isSelected
                            ? Colors.white
                            : isMarked
                            ? Colors
                                .blue // Marked date in blue
                            : Colors.black, // Normal dates in black
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
