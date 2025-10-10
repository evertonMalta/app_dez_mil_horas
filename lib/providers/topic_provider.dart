import 'package:flutter/foundation.dart';
import '../models/study_session.dart';
import '../models/topic.dart';

class TopicProvider with ChangeNotifier {
  List<Topic> _topics = [];

  TopicProvider() {
    _loadMockData();
  }

  List<Topic> get allTopics => [..._topics];

  Topic? getTopicById(String id) {
    Topic? _findTopic(List<Topic> topics, String topicId) {
      for (var topic in topics) {
        if (topic.id == topicId) {
          return topic;
        }
        final foundInSub = _findTopic(topic.subTopics, topicId);
        if (foundInSub != null) {
          return foundInSub;
        }
      }
      return null;
    }
    return _findTopic(_topics, id);
  }

  void addTopic(String title, {String? parentId}) {
    if (parentId == null) {
      _topics.add(Topic(title: title));
    } else {
      final parentTopic = getTopicById(parentId);
      parentTopic?.subTopics.add(Topic(title: title));
    }
    notifyListeners();
  }

  void addStudySession(String topicId, int minutes) {
    final topic = getTopicById(topicId);
    if (topic != null) {
      topic.sessions.add(StudySession(
        durationInMinutes: minutes,
        date: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  void deleteTopic(String topicId) {
    bool recursiveDelete(List<Topic> topics) {
      for (int i = 0; i < topics.length; i++) {
        if (topics[i].id == topicId) {
          topics.removeAt(i);
          return true; 
        }
        if (recursiveDelete(topics[i].subTopics)) {
          return true; 
        }
      }
      return false;
    }

    recursiveDelete(_topics);
    notifyListeners();
  }

  void _loadMockData() {
    _topics = [
      Topic(title: 'Flutter Básico')
        ..sessions.add(StudySession(
          durationInMinutes: 60,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ))
        ..sessions.add(StudySession(
          durationInMinutes: 45,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ))
        ..subTopics.add(
          Topic(title: 'Widgets')
            ..sessions.add(StudySession(
              durationInMinutes: 120,
              date: DateTime.now(),
            )),
        ),
      Topic(title: 'Dart Intermediário')
        ..sessions.add(StudySession(
          durationInMinutes: 90,
          date: DateTime.now().subtract(const Duration(hours: 5)),
        )),
      Topic(title: 'Gerenciamento de Estado'),
    ];
  }
}

