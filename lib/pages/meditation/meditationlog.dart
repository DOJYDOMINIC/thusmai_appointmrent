import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/meditationController.dart';

class MeditationLog extends StatefulWidget {
  const MeditationLog({super.key});

  @override
  State<MeditationLog> createState() => _MeditationLogState();
}

class _MeditationLogState extends State<MeditationLog> {

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeditationController>(context, listen: false).meditatedDates("1");
    // });
  }

  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);
    var data = meditation.medDates;
    // Find the minimum date from your data
    DateTime minDate = DateTime.now(); // Initialize with current date as fallback,
    if (data.isNotEmpty) {
      minDate = data.map((item) => DateTime.parse(item.medStarttime.toString())).reduce((value, element) => value.isBefore(element) ? value : element);
    }
    // Calculate the number of days to display in the calendar
    DateTime startDate = minDate.subtract(Duration(days: 1)); // Subtract one day to include the starting date

    return Scaffold(
      backgroundColor: shadeOne,
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: meditationLogGreen,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.sp),
                  child: Text("Days Meditated"),
                ),
                Text("   : ${meditation.greenCount}"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: meditationLogRed,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.sp),
                  child: Text("Days Missed"),
                ),
                Text(" : ${meditation.redCount}")
              ],
            ),
            SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                // physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                children: List.generate(
                  data.length+meditation.redCount,
                      (index) {
                    DateTime currentDate = startDate.add(Duration(days: index));
                    bool isGreen = data.any((item) {
                      if (item.medStarttime != null) {
                        DateTime medDate = DateTime.parse(item.medStarttime.toString());
                        return medDate.day == currentDate.day && medDate.month == currentDate.month;
                      }
                      return false;
                    });
                    String formattedDate = DateFormat('MMM\ndd').format(currentDate);

                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 64.w,
                        decoration: BoxDecoration(
                          color: isGreen ? meditationLogGreen : meditationLogRed,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "${formattedDate.toString()}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(flex: 4),
                  Text("${meditation.meditatedDatesIndex} of ${meditation.meditatedDatesTotalPage}"),
                  Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: ()  {
                             meditation.meditatedDatesSubtract();
                          },
                          icon: Icon(Icons.chevron_left),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: ()  {
                             meditation.meditatedDatesAdd(meditation.meditatedDatesTotalPage - 1);
                          },
                          icon: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
