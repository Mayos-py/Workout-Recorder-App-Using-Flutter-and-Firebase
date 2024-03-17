

import 'package:floor/floor.dart';

@entity
class Emotion{
  @primaryKey
  final int ?emotion_Id;

  final String emotion;
  final String recordedDateTime;

  Emotion(this.emotion_Id, this.emotion, this.recordedDateTime);
}