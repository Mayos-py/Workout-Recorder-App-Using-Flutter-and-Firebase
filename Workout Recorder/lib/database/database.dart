
import 'package:firstapp/dao/emotionDAO.dart';
import 'package:firstapp/dao/dietDAO.dart';
import 'package:firstapp/dao/workoutDAO.dart';
import 'package:firstapp/entity/RecordingPoints.dart';
import 'package:firstapp/entity/workout.dart';
import 'package:floor/floor.dart';
import 'package:firstapp/entity/emotions.dart';
import 'package:firstapp/entity/diet.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/recordingDAO.dart';
part 'database.g.dart';

@Database(version: 1, entities:[Emotion, Diet, Workout, Status])
abstract class AppDatabase extends FloorDatabase{
  EmotionDao get emotionDAO;
  DietDao get dietDAO;
  WorkoutDao get workoutDAO;
  recordingDao get StatusDAO;
}
