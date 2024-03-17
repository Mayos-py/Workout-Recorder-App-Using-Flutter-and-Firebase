

import 'package:floor/floor.dart';

@entity
class Status{
  @primaryKey
  final int ?status_Id;

  final int lastRecordedTime;
  int recordingPoints;
  String ?lastRecordedType;

  Status(this.status_Id, this.recordingPoints, this.lastRecordedTime, this.lastRecordedType);
}