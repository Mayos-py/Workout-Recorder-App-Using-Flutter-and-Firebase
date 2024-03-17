import 'package:flutter/foundation.dart';
import 'dart:math';
import 'database/database.dart';
import 'entity/RecordingPoints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordingProvider with ChangeNotifier {
  final AppDatabase database;
  RecordingProvider(this.database);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime lastRecordingTime = DateTime.now();
  int recordingPoints = 0;
  String? lastEventType;

  Future<void> fetchData() async {
    final List<Status> statusList = await database.StatusDAO.getLatestRecord();
    if (statusList.isNotEmpty) {
      final Status status = statusList.first;
      lastRecordingTime = DateTime.fromMillisecondsSinceEpoch(status.lastRecordedTime);
      recordingPoints = status.recordingPoints;
      lastEventType = status.lastRecordedType;
    }
  }

  Future<void> addEvents(Status status) async {
    await database.StatusDAO.addStatus(status);
  }

  Future<void> addPointsToFirebase(userEmail, points) async {
    await updateUserPointsInFirestore(userEmail, recordingPoints);
  }

  void recordEvent(String eventType, DateTime lastTime) {
    fetchData();
    Duration timeSinceLastRecording = lastTime.difference(lastRecordingTime ?? lastTime);

    int pointsEarned = calculatePoints(timeSinceLastRecording);

    lastRecordingTime = lastTime;
    recordingPoints += pointsEarned;
    lastEventType = eventType;

    final status = Status(null, recordingPoints, lastRecordingTime.millisecondsSinceEpoch, lastEventType);
    print(lastRecordingTime);
    addEvents(status);

    User? user = _auth.currentUser;
    if (user != null) {
      print("User Is there");
      addPointsToFirebase(user.email, recordingPoints);
    }
    notifyListeners();
  }

  int calculatePoints(Duration timeSinceLastRecording) {
    double hours = timeSinceLastRecording.inHours.toDouble();
    int maxPoints = 100;
    int points = (log(hours + 1) * 10).toInt();

    return min(points, maxPoints);
  }

  int calculateDedicationLevel() {
    return recordingPoints ~/ 10;
  }
}

Future<void> updateUserPointsInFirestore(String userEmail, int points) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  await firestore.collection('Points').doc(userEmail).set({
    'email': userEmail,
    'points': points,
  });
}
