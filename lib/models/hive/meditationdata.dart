import 'package:hive/hive.dart';

part 'meditationdata.g.dart';

@HiveType(typeId: 0)
class MeditationData extends HiveObject {
  @HiveField(0)
  String startTime;

  @HiveField(1)
  String endTime;

  MeditationData({required this.startTime, required this.endTime});
}
