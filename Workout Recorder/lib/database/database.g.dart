// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EmotionDao? _emotionDAOInstance;

  DietDao? _dietDAOInstance;

  WorkoutDao? _workoutDAOInstance;

  recordingDao? _StatusDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Emotion` (`emotion_Id` INTEGER, `emotion` TEXT NOT NULL, `recordedDateTime` TEXT NOT NULL, PRIMARY KEY (`emotion_Id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Diet` (`diet_Id` INTEGER, `food` TEXT NOT NULL, `quantity` TEXT NOT NULL, `recordedDateTime` TEXT NOT NULL, PRIMARY KEY (`diet_Id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Workout` (`workout_id` INTEGER, `workout` TEXT NOT NULL, `quantity` TEXT NOT NULL, `recordedDateTime` TEXT NOT NULL, PRIMARY KEY (`workout_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Status` (`status_Id` INTEGER, `lastRecordedTime` INTEGER NOT NULL, `recordingPoints` INTEGER NOT NULL, `lastRecordedType` TEXT, PRIMARY KEY (`status_Id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EmotionDao get emotionDAO {
    return _emotionDAOInstance ??= _$EmotionDao(database, changeListener);
  }

  @override
  DietDao get dietDAO {
    return _dietDAOInstance ??= _$DietDao(database, changeListener);
  }

  @override
  WorkoutDao get workoutDAO {
    return _workoutDAOInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  recordingDao get StatusDAO {
    return _StatusDAOInstance ??= _$recordingDao(database, changeListener);
  }
}

class _$EmotionDao extends EmotionDao {
  _$EmotionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _emotionInsertionAdapter = InsertionAdapter(
            database,
            'Emotion',
            (Emotion item) => <String, Object?>{
                  'emotion_Id': item.emotion_Id,
                  'emotion': item.emotion,
                  'recordedDateTime': item.recordedDateTime
                }),
        _emotionDeletionAdapter = DeletionAdapter(
            database,
            'Emotion',
            ['emotion_Id'],
            (Emotion item) => <String, Object?>{
                  'emotion_Id': item.emotion_Id,
                  'emotion': item.emotion,
                  'recordedDateTime': item.recordedDateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Emotion> _emotionInsertionAdapter;

  final DeletionAdapter<Emotion> _emotionDeletionAdapter;

  @override
  Future<List<Emotion>> getEmotions() async {
    return _queryAdapter.queryList('SELECT * FROM Emotion',
        mapper: (Map<String, Object?> row) => Emotion(row['emotion_Id'] as int?,
            row['emotion'] as String, row['recordedDateTime'] as String));
  }

  @override
  Future<void> addEmotion(Emotion emotion) async {
    await _emotionInsertionAdapter.insert(emotion, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEmotion(Emotion emotion) async {
    await _emotionDeletionAdapter.delete(emotion);
  }
}

class _$DietDao extends DietDao {
  _$DietDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dietInsertionAdapter = InsertionAdapter(
            database,
            'Diet',
            (Diet item) => <String, Object?>{
                  'diet_Id': item.diet_Id,
                  'food': item.food,
                  'quantity': item.quantity,
                  'recordedDateTime': item.recordedDateTime
                }),
        _dietUpdateAdapter = UpdateAdapter(
            database,
            'Diet',
            ['diet_Id'],
            (Diet item) => <String, Object?>{
                  'diet_Id': item.diet_Id,
                  'food': item.food,
                  'quantity': item.quantity,
                  'recordedDateTime': item.recordedDateTime
                }),
        _dietDeletionAdapter = DeletionAdapter(
            database,
            'Diet',
            ['diet_Id'],
            (Diet item) => <String, Object?>{
                  'diet_Id': item.diet_Id,
                  'food': item.food,
                  'quantity': item.quantity,
                  'recordedDateTime': item.recordedDateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Diet> _dietInsertionAdapter;

  final UpdateAdapter<Diet> _dietUpdateAdapter;

  final DeletionAdapter<Diet> _dietDeletionAdapter;

  @override
  Future<List<Diet>> getDietRecords() async {
    return _queryAdapter.queryList('SELECT * FROM Diet',
        mapper: (Map<String, Object?> row) => Diet(
            row['diet_Id'] as int?,
            row['food'] as String,
            row['quantity'] as String,
            row['recordedDateTime'] as String));
  }

  @override
  Future<void> addDietRecords(Diet diet) async {
    await _dietInsertionAdapter.insert(diet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateQuantity(Diet diet) async {
    await _dietUpdateAdapter.update(diet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDiet(Diet diet) async {
    await _dietDeletionAdapter.delete(diet);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutInsertionAdapter = InsertionAdapter(
            database,
            'Workout',
            (Workout item) => <String, Object?>{
                  'workout_id': item.workout_id,
                  'workout': item.workout,
                  'quantity': item.quantity,
                  'recordedDateTime': item.recordedDateTime
                }),
        _workoutDeletionAdapter = DeletionAdapter(
            database,
            'Workout',
            ['workout_id'],
            (Workout item) => <String, Object?>{
                  'workout_id': item.workout_id,
                  'workout': item.workout,
                  'quantity': item.quantity,
                  'recordedDateTime': item.recordedDateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Workout> _workoutInsertionAdapter;

  final DeletionAdapter<Workout> _workoutDeletionAdapter;

  @override
  Future<List<Workout>> getWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM Workout',
        mapper: (Map<String, Object?> row) => Workout(
            row['workout_id'] as int?,
            row['workout'] as String,
            row['quantity'] as String,
            row['recordedDateTime'] as String));
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    await _workoutInsertionAdapter.insert(workout, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWorkout(Workout workout) async {
    await _workoutDeletionAdapter.delete(workout);
  }
}

class _$recordingDao extends recordingDao {
  _$recordingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statusInsertionAdapter = InsertionAdapter(
            database,
            'Status',
            (Status item) => <String, Object?>{
                  'status_Id': item.status_Id,
                  'lastRecordedTime': item.lastRecordedTime,
                  'recordingPoints': item.recordingPoints,
                  'lastRecordedType': item.lastRecordedType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Status> _statusInsertionAdapter;

  @override
  Future<List<Status>> getStatus() async {
    return _queryAdapter.queryList('SELECT * FROM Status',
        mapper: (Map<String, Object?> row) => Status(
            row['status_Id'] as int?,
            row['recordingPoints'] as int,
            row['lastRecordedTime'] as int,
            row['lastRecordedType'] as String?));
  }

  @override
  Future<List<Status>> getLatestRecord() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Status ORDER BY lastRecordedTime DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => Status(
            row['status_Id'] as int?,
            row['recordingPoints'] as int,
            row['lastRecordedTime'] as int,
            row['lastRecordedType'] as String?));
  }

  @override
  Future<void> addStatus(Status status) async {
    await _statusInsertionAdapter.insert(status, OnConflictStrategy.abort);
  }
}
