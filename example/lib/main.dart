import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final today = DateUtils.dateOnly(DateTime.now());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalendarDatePicker2 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('he', ''),
        Locale('es', ''),
        Locale('ru', ''),
        Locale('ko', ''),
        Locale('hi', ''),
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        title: const Text("Research Custom DatePicker"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF101828)
                        .withOpacity(0.03), // Shadow color
                    spreadRadius: -4, // Spread radius
                    blurRadius: 8, // Blur radius
                    offset: const Offset(0, 8), // Offset in x and y direction
                  ),
                  BoxShadow(
                    color: const Color(0xFF101828)
                        .withOpacity(0.08), // Shadow color
                    spreadRadius: -4, // Spread radius
                    blurRadius: 24, // Blur radius
                    offset: const Offset(
                      0,
                      20,
                    ), // Offset in x and y direction
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.range,
                      rangeBidirectional: true,
                      lastDate: DateTime.now(),
                      calendarViewMode: CalendarDatePicker2Mode.day,
                      firstDayOfWeek: 1,
                      selectedRangeHighlightColor: const Color(0xFFE5EEE7),
                      selectedDayHighlightColor: const Color(0xFF3B6B46),
                      weekdayLabelTextStyle:
                          Theme.of(context).textTheme.bodyMedium,
                      dayTextStyle: Theme.of(context).textTheme.bodyMedium,
                      dayMaxWidth: 40,
                      weekdayLabels: [
                        "CN",
                        "T2",
                        "T3",
                        "T4",
                        "T5",
                        "T6",
                        "T7",
                      ],
                    ),
                    value: const [],
                    displayedMonthDate: DateTime.now(),
                    onValueChanged: (dates) {},
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 0,
                  color: Color(0xFFE4E7EC),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Hủy",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF3B6B46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Áp dụng",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
