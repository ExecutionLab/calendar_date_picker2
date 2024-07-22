part of '../calendar_date_picker2.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The month picker widget is rarely used directly. Instead, consider using [CalendarDatePicker2]
///
/// See also:
///
///  * [CalendarDatePicker2], which provides a Material Design date picker
///    interface.
///
///
class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  const _MonthPicker({
    required this.config,
    required this.selectedDates,
    required this.onChanged,
    required this.initialMonth,
    required this.handleYearChange,
    Key? key,
  }) : super(key: key);

  ///
  final Function(DateTime value, [bool autoSwitchMode]) handleYearChange;

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialMonth;

  @override
  State<_MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  late ScrollController _scrollController;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    final scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForMonth(widget.selectedDates[0]!)
            : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
    _scrollController = widget.config.monthViewController ??
        ScrollController(initialScrollOffset: scrollOffset);
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForMonth(widget.selectedDates[0]!)
              : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterialLocalizations(context));
    _locale = Localizations.localeOf(context);
  }

  double _scrollOffsetForMonth(DateTime date) {
    final int initialMonthIndex = date.month - DateTime.january;
    final int initialMonthRow = initialMonthIndex ~/ _monthPickerColumnCount;
    final int centeredMonthRow = initialMonthRow - 2;
    return centeredMonthRow * _monthPickerRowHeight;
  }

  Widget _buildMonthItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int month = 1 + index;
    final bool isCurrentMonth =
        widget.initialMonth.year == widget.config.currentDate.year &&
            widget.config.currentDate.month == month;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final bool isSelected = widget.selectedDates.isNotEmpty &&
        widget.selectedDates.any((date) =>
            date != null &&
            widget.initialMonth.year == date.year &&
            date.month == month);
    var isMonthSelectable =
        widget.initialMonth.year >= widget.config.firstDate.year &&
            widget.initialMonth.year <= widget.config.lastDate.year;
    if (isMonthSelectable) {
      if (widget.initialMonth.year == widget.config.firstDate.year) {
        isMonthSelectable = month >= widget.config.firstDate.month;
      }

      if (widget.initialMonth.year == widget.config.lastDate.year) {
        isMonthSelectable = month <= widget.config.lastDate.month;
      }
    }
    final monthSelectableFromPredicate = widget.config.selectableMonthPredicate
            ?.call(widget.initialMonth.year, month) ??
        true;
    isMonthSelectable = isMonthSelectable && monthSelectableFromPredicate;

    final Color textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (!isMonthSelectable) {
      textColor = colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentMonth) {
      textColor =
          widget.config.selectedDayHighlightColor ?? colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withOpacity(0.87);
    }

    TextStyle? itemStyle = widget.config.monthTextStyle ??
        textTheme.bodyLarge?.apply(color: textColor);
    if (isSelected) {
      itemStyle = widget.config.selectedMonthTextStyle ?? itemStyle;
    }

    BoxDecoration? decoration;

    decoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: const Color(0xFFF0F1F0),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05), // Shadow color
          spreadRadius: 2, // How much the shadow spreads
          blurRadius: 5, // How much the shadow blurs
          offset: const Offset(0, 1), // The position of the shadow
        ),
      ],
      borderRadius: widget.config.monthBorderRadius ??
          BorderRadius.circular(decorationHeight / 2),
    );

    if (isSelected) {
      decoration = BoxDecoration(
        color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        borderRadius: widget.config.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
      itemStyle = itemStyle?.copyWith(color: Colors.white);
    } else if (isCurrentMonth && isMonthSelectable) {
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        ),
        borderRadius: widget.config.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    }

    Locale currentLocale = Localizations.localeOf(context);

    Widget monthItem = widget.config.monthBuilder?.call(
          month: month,
          textStyle: itemStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: !isMonthSelectable,
          isCurrentMonth: isCurrentMonth,
        ) ??
        Center(
          child: Container(
            decoration: decoration,
            height: decorationHeight,
            width: decorationWidth,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Text(
                  currentLocale.languageCode == "vi"
                      ? "Tháng $month"
                      : getLocaleShortMonthFormat(_locale).format(
                          DateTime(widget.initialMonth.year, month),
                        ),
                  style: itemStyle,
                ),
              ),
            ),
          ),
        );

    if (!isMonthSelectable) {
      monthItem = ExcludeSemantics(
        child: monthItem,
      );
    } else {
      monthItem = InkWell(
        key: ValueKey<int>(month),
        onTap: !isMonthSelectable
            ? null
            : () {
                widget.onChanged(DateUtils.dateOnly(
                  DateTime(widget.initialMonth.year, month),
                ));
              },
        child: monthItem,
      );
    }

    return monthItem;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: IconButton(
                    splashRadius: widget.config.dayMaxWidth != null
                        ? widget.config.dayMaxWidth! * 2 / 3
                        : null,
                    icon: widget.config.lastMonthIcon ??
                        const Icon(Icons.chevron_left),
                    onPressed: () => widget.handleYearChange(
                      DateTime(widget.initialMonth.year - 1),
                      false,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "${widget.initialMonth.year}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: IconButton(
                    splashRadius: widget.config.dayMaxWidth != null
                        ? widget.config.dayMaxWidth! * 2 / 3
                        : null,
                    icon: widget.config.nextMonthIcon ??
                        const Icon(Icons.chevron_right),
                    onPressed: () => widget.handleYearChange(
                      DateTime(widget.initialMonth.year + 1),
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: widget.config.hideMonthPickerDividers == true
                ? Colors.transparent
                : null,
            height: 0,
            thickness: 0,
          ),
          Container(
            // constraints: const BoxConstraints(
            //   maxHeight: 248,
            // ),
            height: 216,
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: _monthPickerGridDelegate,
              itemBuilder: _buildMonthItem,
              itemCount: 12,
              // padding:
              //     const EdgeInsets.symmetric(horizontal: _monthPickerPadding),
            ),
          ),
          Divider(
            color: widget.config.hideMonthPickerDividers == true
                ? Colors.transparent
                : null,
            height: 0,
            thickness: 0,
          ),
        ],
      ),
    );
  }
}

class _MonthPickerGridDelegate extends SliverGridDelegate {
  const _MonthPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_monthPickerColumnCount - 1) * _monthPickerRowSpacing) /
        _monthPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _monthPickerRowHeight,
      crossAxisCount: _monthPickerColumnCount,
      crossAxisStride: tileWidth + _monthPickerRowSpacing,
      mainAxisStride: _monthPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthPickerGridDelegate oldDelegate) => false;
}

const _MonthPickerGridDelegate _monthPickerGridDelegate =
    _MonthPickerGridDelegate();
