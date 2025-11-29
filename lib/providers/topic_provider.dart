import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/study_session.dart';
import '../models/topic.dart';

class TopicProvider with ChangeNotifier {
  List<Topic> _topics = [];
  StreamSubscription<QuerySnapshot>? _topicsSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Topic> get allTopics => [..._topics];

  TopicProvider() {
    _init();
  }

  void _init() {
    final user = _auth.currentUser;
    if (user != null) {
      _subscribeToTopics(user.uid);
    }

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToTopics(user.uid);
      } else {
        _topics = [];
        _topicsSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  void _subscribeToTopics(String userId) {
    _topicsSubscription?.cancel();
    _topicsSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('topics')
        .snapshots()
        .listen((snapshot) async {
          final allDocs = snapshot.docs
              .map((doc) => Topic.fromMap(doc.data()))
              .toList();

          _topics = _buildTopicTree(allDocs);

          for (var topic in allDocs) {
            _fetchSessions(userId, topic);
          }

          notifyListeners();
        });
  }

  List<Topic> _buildTopicTree(List<Topic> allTopics) {
    final topicMap = {for (var t in allTopics) t.id: t};
    final List<Topic> rootTopics = [];

    for (var topic in allTopics) {
      if (topic.parentId == null) {
        rootTopics.add(topic);
      } else {
        final parent = topicMap[topic.parentId];
        if (parent != null) {
          parent.subTopics.add(topic);
        } else {
          rootTopics.add(topic);
        }
      }
    }
    return rootTopics;
  }

  Future<void> _fetchSessions(String userId, Topic topic) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .where('topicId', isEqualTo: topic.id)
        .get();

    final sessions = snapshot.docs
        .map((doc) => StudySession.fromMap(doc.data()))
        .toList();

    topic.sessions.clear();
    topic.sessions.addAll(sessions);
    notifyListeners();
  }

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

  Future<void> addTopic(String title, {String? parentId}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newTopic = Topic(title: title, userId: user.uid, parentId: parentId);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('topics')
        .doc(newTopic.id)
        .set(newTopic.toMap());
  }

  Future<void> addStudySession(String topicId, int minutes) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final topic = getTopicById(topicId);
    if (topic != null) {
      final session = StudySession(
        durationInMinutes: minutes,
        date: DateTime.now(),
      );

      final sessionMap = session.toMap();
      sessionMap['topicId'] = topicId;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sessions')
          .doc(session.id)
          .set(sessionMap);

      topic.sessions.add(session);
      notifyListeners();
    }
  }

  Future<void> deleteTopic(String topicId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final topic = getTopicById(topicId);
    if (topic == null) return;

    await _recursiveDelete(user.uid, topic);
  }

  Future<void> _recursiveDelete(String userId, Topic topic) async {
    for (var sub in List<Topic>.from(topic.subTopics)) {
      await _recursiveDelete(userId, sub);
    }

    final sessionsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .where('topicId', isEqualTo: topic.id)
        .get();

    for (var doc in sessionsSnapshot.docs) {
      await doc.reference.delete();
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('topics')
        .doc(topic.id)
        .delete();
  }

  Future<void> updateTopic(String topicId, String newTitle) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final topic = getTopicById(topicId);
    if (topic == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('topics')
        .doc(topicId)
        .update({'title': newTitle});

  }

  Future<void> deleteSession(String topicId, String sessionId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final topic = getTopicById(topicId);
    if (topic == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .doc(sessionId)
        .delete();

    topic.sessions.removeWhere((s) => s.id == sessionId);
    notifyListeners();
  }
}
