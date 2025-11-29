import 'package:uuid/uuid.dart';
import './study_session.dart';

class Topic {
  final String id;
  final String title;
  final String userId;
  final String? parentId;
  final List<Topic> subTopics;
  final List<StudySession> sessions;

  Topic({
    String? id,
    required this.title,
    required this.userId,
    this.parentId,
    List<Topic>? subTopics,
    List<StudySession>? sessions,
  }) : id = id ?? const Uuid().v4(),
       subTopics = subTopics ?? [],
       sessions = sessions ?? [];

  int get totalMinutesStudied {
    final int directMinutes = sessions.fold(
      0,
      (sum, session) => sum + session.durationInMinutes,
    );

    final int subTopicsMinutes = subTopics.fold(
      0,
      (sum, subTopic) => sum + subTopic.totalMinutesStudied,
    );

    return directMinutes + subTopicsMinutes;
  }

  String get totalTimeFormatted {
    if (totalMinutesStudied == 0) {
      return '0m';
    }
    final hours = totalMinutesStudied ~/ 60;
    final minutes = totalMinutesStudied % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'userId': userId, 'parentId': parentId};
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String?,
      title: map['title'] as String,
      userId: map['userId'] as String,
      parentId: map['parentId'] as String?,
    );
  }
}
