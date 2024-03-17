


import 'package:firstapp/entity/RecordingPoints.dart';
import 'package:floor/floor.dart';

@dao
abstract class recordingDao{

  @Query("SELECT * FROM Status")
  Future<List<Status>> getStatus();

  @Query("SELECT * FROM Status ORDER BY lastRecordedTime DESC LIMIT 1")
  Future<List<Status>> getLatestRecord();

  @insert
  Future<void> addStatus(Status status);


}