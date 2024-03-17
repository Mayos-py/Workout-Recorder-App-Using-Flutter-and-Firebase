
import 'package:firstapp/entity/workout.dart';
import 'package:floor/floor.dart';

@dao
abstract class WorkoutDao{

  @Query("SELECT * FROM Workout")
  Future<List<Workout>> getWorkouts();

  @insert
  Future<void> addWorkout(Workout workout);

  @delete
  Future<void> deleteWorkout(Workout workout);
}