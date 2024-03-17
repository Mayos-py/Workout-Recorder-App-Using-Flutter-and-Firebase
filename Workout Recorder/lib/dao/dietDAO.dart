

import 'package:floor/floor.dart';
import 'package:firstapp/entity/diet.dart';

@dao
abstract class DietDao{

  @Query("SELECT * FROM Diet")
  Future<List<Diet>> getDietRecords();

  @insert
  Future<void> addDietRecords(Diet diet);

  @delete
  Future<void> deleteDiet(Diet diet);

  @update
  Future<void> updateQuantity(Diet diet);
}