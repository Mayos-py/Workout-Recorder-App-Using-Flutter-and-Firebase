


import 'package:firstapp/entity/emotions.dart';
import 'package:floor/floor.dart';

@dao
abstract class EmotionDao{

  @Query("SELECT * FROM Emotion")
  Future<List<Emotion>> getEmotions();

  @insert
  Future<void> addEmotion(Emotion emotion);

  @delete
  Future<void> deleteEmotion(Emotion emotion);
}