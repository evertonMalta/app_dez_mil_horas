import 'package:uuid/uuid.dart';

class StudySession {
  final String id;
  final DateTime date;
  final int durationInMinutes;

  StudySession({
    String? id,
    required this.date,
    required this.durationInMinutes,
  }) : id = id ?? const Uuid().v4();
}
