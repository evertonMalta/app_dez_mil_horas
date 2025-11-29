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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'durationInMinutes': durationInMinutes,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] as String?,
      date: DateTime.parse(map['date'] as String),
      durationInMinutes: map['durationInMinutes'] as int,
    );
  }
}
