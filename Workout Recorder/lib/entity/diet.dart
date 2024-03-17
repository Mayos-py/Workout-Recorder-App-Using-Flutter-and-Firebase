

import 'package:floor/floor.dart';

@entity
class Diet{
  @primaryKey
  final int ?diet_Id;

  final String food;
  String quantity;
  final String recordedDateTime;

  Diet(this.diet_Id, this.food, this.quantity, this.recordedDateTime);
}