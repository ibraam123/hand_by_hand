import 'package:hive_flutter/hive_flutter.dart';
part 'notification_model.g.dart';


@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

}