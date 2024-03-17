

import 'package:floor/floor.dart';

@entity
class Workout{
  @primaryKey
  final int ?workout_id;

  final String workout;
  String quantity;
  final String recordedDateTime;

  Workout(this.workout_id, this.workout, this.quantity, this.recordedDateTime);
}