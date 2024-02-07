import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/height.dart';
import 'package:gym_tracker/models/set_weight.dart';
import 'package:gym_tracker/models/user.dart';
import 'package:gym_tracker/models/user_height.dart';
import 'package:gym_tracker/models/user_weigth.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/providers/sets_provider.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import '../models/set.dart';

class AppDatabase {
  static final String userDBName = 'user_db.db';
  static final String userTableName = 'user';

  static final String weightsDBName = 'weights_db.db';
  static final String weightsTableName = 'weights';

  static final String workoutsDBName = 'workouts_db.db';
  static final String workoutsTableName = 'workouts';

  static final String exercisesDBName = 'exercises_db.db';
  static final String exercisesTableName = 'exercises';

  static final String sessionsDBName = 'sessions_db.db';
  static final String exerciseSessionsTableName = 'exercise_sessions';
  static final String workoutSessionsTableName = 'workout_sessions';
  static final String setsTableName = 'sets';
  static final String setsWeightTableName = 'sets_weight';
  AppDatabase();

  ////////////////////////////////////// USER DB
  Future<Database> _getUserDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, userDBName),
      version: 2,
      onCreate: (db, version) => _createUserTable(db, version),
    );
  }

  Future<void> _createUserTable(var db, var version) {
    db.execute(
        'CREATE TABLE $userTableName ( id TEXT, name TEXT, height FLOAT, body TEXT, gender TEXT, weight_unit TEXT DEFAULT \"lb\", height_unit TEXT DEFAULT \"in\", birthday DATETIME, image TEXT)');
    db.execute(
        'INSERT INTO $userTableName VALUES(\"${UniqueKey().toString()}\" , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)');
  }

  insertUser(Map<String, Object> data) async {
    final sqlDb = await _getUserDB();
    sqlDb.insert(userTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  updateUserInfo(data) async {
    final db = await _getUserDB();
    db.update(userTableName, data);
    var user = await db.query('user');
    print('updated user to: ' + user.toString());
  }

  getUser(context, userProvider) async {
    final db = await _getUserDB();
    var userTable = await db.query(userTableName);
    var userData = userTable.first;
    var heightUnit = (userData['height_unit'] != null)
        ? Unit.mapToUnit(userData['height_unit'])
        : null;
    User user = new User(
      id: (userData['id'] != null) ? userData['id'] : UniqueKey().toString(),
      name: userData['name'],
      image: userData['image'],
      birthday: (userData['birthday'] != null)
          ? DateTime.parse(userData['birthday'])
          : null,
      gender: userData['gender'],
      bodyType: userData['body'],
      height: UserHeight(
          id: UniqueKey().toString(),
          height: Height.mapToHeight(userData['height'], heightUnit)),
      heightUnit: heightUnit,
      weightUnit: (userData['weight_unit'] != null)
          ? Unit.mapToUnit(userData['weight_unit'])
          : null,
    );

    if (userProvider.user.id == null) userProvider.setUser(user);
    return userProvider;
  }

  //////////////////////////////////////  WEIGHTS DB
  Future<Database> _getWeightsDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, weightsDBName),
      version: 2,
      onCreate: (db, version) => _createUserWeightsTable(db, version),
    );
  }

  Future<void> _createUserWeightsTable(var db, var version) {
    return db.execute(
        'CREATE TABLE $weightsTableName ( id TEXT PRIMARY KEY, lb FLOAT, kg FLOAT, date DATETIME )');
  }

  insertWeight(Map<String, Object> data) async {
    final sqlDb = await _getWeightsDB();
    sqlDb.insert(weightsTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  removeWeight(String id) async {
    final sqlDb = await _getWeightsDB();
    sqlDb.execute(
        'DELETE FROM $weightsTableName WHERE id = \'${id.toString()}\'');
    var table = await sqlDb.query(weightsTableName);
    print('Removed weights with ids: ' + id.toString());
    print('Updated weights to: ' + table.toString());
  }

  getWeightsList(context, userProvider) async {
    final sqlDb = await _getWeightsDB();
    final weightsTable = await sqlDb.query(weightsTableName);
    List<UserWeight> weights = [];
    weightsTable.forEach(
      (weightData) => {
        weights.add(
          UserWeight(
            id: weightData['id'],
            date: (weightData['date'] != null)
                ? DateTime.parse(weightData['date'])
                : null,
            weight: Weight(
              kg: weightData['kg'],
            ), //'lb' will automatically be calculated
          ),
        )
      },
    );

    if (userProvider.userWeightsList.length == 0)
      userProvider.setUserWeights(weights);
    return userProvider.userWeightsList;
  }

  getWeightById(String id) async {
    final sqlDb = await _getWeightsDB();
    var weight =
        await sqlDb.query(weightsTableName, where: 'id', whereArgs: [id]);
    return weight.first;
  }

  ////////////////////////////////////// WORKOUTS DB
  Future<Database> _getWorkoutsDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, workoutsDBName),
      version: 2,
      onCreate: (db, version) => _createWorkoutsTable(db, version),
    );
  }

  Future<void> _createWorkoutsTable(var db, var version) {
    return db.execute(
        'CREATE TABLE $workoutsTableName ( id TEXT PRIMARY KEY, name TEXT, about TEXT, intensity TEXT, icon_code TEXT, exercises TEXT)');
  }

  insertWorkout(Map<String, Object> data) async {
    final sqlDb = await _getWorkoutsDB();
    sqlDb.insert(workoutsTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  removeWorkout(String id) async {
    final sqlDb = await _getWorkoutsDB();
    sqlDb.execute(
        'DELETE FROM $workoutsTableName WHERE id = \'${id.toString()}\'');
    var table = await sqlDb.query(workoutsTableName);
    print('Removed workout with id ${id.toString()}:');
    print(table);
  }

  getWorkoutsList(context, WorkoutsProvider workoutsProvider) async {
    final sqlDb = await _getWorkoutsDB();
    final workoutsTable = await sqlDb.query(workoutsTableName);
    List<Workout> workouts = [];
    workoutsTable.forEach(
      (workoutData) => {
        workouts.add(
          Workout(
            id: workoutData['id'],
            name: workoutData['name'],
            about: workoutData['about'],
            level: Intensity.mapToIntensityLevel(workoutData['intensity']),
            icon: (workoutData['icon_code'] != null)
                ? IconData(
                    int.parse(workoutData['icon_code'].split(':')[1],
                        radix: 16),
                    fontFamily: workoutData['icon_code'].split(':')[0],
                  )
                : null,
            exercises:
                Exercise.mapListFromString(workoutData['exercises'], context),
          ),
        ),
      },
    );

    if (workoutsProvider.workoutsList.length == 0)
      workoutsProvider.setWorkouts(workouts);
    return workoutsProvider.workoutsList;
  }

  getWorkoutById(String id) async {
    final sqlDb = await _getWorkoutsDB();
    var workout =
        await sqlDb.query(workoutsTableName, where: 'id', whereArgs: [id]);
    return workout.first;
  }

  ////////////////////////////////////// EXERCISES DB
  Future<Database> _getExercisesDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, exercisesDBName),
      version: 2,
      onCreate: (db, version) => _createExercisesTable(db, version),
    );
  }

  Future<void> _createExercisesTable(var db, var version) {
    return db.execute(
        'CREATE TABLE $exercisesTableName ( id TEXT PRIMARY KEY, name TEXT, about TEXT, intensity TEXT, icon_code TEXT, equipment TEXT, body_parts TEXT )');
  }

  insertExercise(Map<String, Object> data) async {
    final sqlDb = await _getExercisesDB();
    sqlDb.insert(exercisesTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('added exercise with id: ${data['id']}:');
  }

  removeExercise(String id) async {
    final sqlDb = await _getExercisesDB();
    sqlDb.execute('DELETE FROM $exercisesTableName WHERE id = \'${id.toString()}\'');
    var table = await sqlDb.query(exercisesTableName);
    print('Removed exercise with id: ${id.toString()}:');
    print(table);
  }
 
  getExercisesList(context, ExercisesProvider exercisesProvider) async {
    final sqlDb = await _getExercisesDB();
    final exercisesTable = await sqlDb.query(exercisesTableName);
    List<Exercise> exercises = [];
    exercisesTable.forEach(
      (exerciseData) => {
        exercises.add(
          Exercise(
              id: exerciseData['id'],
              name: exerciseData['name'],
              about: exerciseData['about'],
              level: Intensity.mapToIntensityLevel(exerciseData['intensity']),
              icon: (exerciseData['icon_code'] != null)
                  ? IconData(
                      int.parse(
                        exerciseData['icon_code'].split(':')[1],
                        radix: 16,
                      ),
                      fontFamily: exerciseData['icon_code'].split(':')[0],
                    )
                  : null,
              bodyParts:
                  HumanBody.mapToBodyPartsList(exerciseData['body_parts']),
              equipment: exerciseData['equipment']),
        ),
      },
    );

    if (exercisesProvider.exercisesList.isEmpty)
      exercisesProvider.setExercises(exercises);
    return exercisesProvider.exercisesList;
  }

  getExerciseById(String id) async {
    final sqlDb = await _getExercisesDB();
    var exercise =
        await sqlDb.query(exercisesTableName, where: 'id', whereArgs: [id]);
    return exercise.first;
  }

  /////////////////////////////////////// SESSIONS DB
  Future<Database> _getSessionsDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, sessionsDBName),
      version: 2,
      onCreate: (db, version) => _createSessionsDbTables(db, version),
    );
  }

  Future<void> _createSessionsDbTables(var db, var version) {
    db.execute(
      'CREATE TABLE $setsWeightTableName ( id TEXT PRIMARY KEY, lb FLOAT, kg FLOAT )',
    );
    db.execute(
      'CREATE TABLE $setsTableName ( id TEXT PRIMARY KEY, exercise_session_id TEXT, weight_id TEXT, reps INTEGER )',
    );
    db.execute(
      'CREATE TABLE $workoutSessionsTableName ( id TEXT PRIMARY KEY, millisecs_duration INTEGER, date DATETIME, session_workout_id TEXT)',
    );
    db.execute(
      'CREATE TABLE $exerciseSessionsTableName ( id TEXT PRIMARY KEY, workout_id TEXT, exercise_id TEXT, millisecs_duration INTEGER, note TEXT )',
    );
  }

  insertWorkoutSession(Map<String, Object> data) async {
    _insertInSessionsDb(tableName: workoutSessionsTableName, data: data);
  }

  removeWorkoutSession(sessionId) async {
    _removeFromSessionsDb(tableName: workoutSessionsTableName, id: sessionId);
  }

  removeExerciseSession(sessionId) async {
    _removeFromSessionsDb(tableName: exerciseSessionsTableName, id: sessionId);
  }

  removeSet(id) {
    _removeFromSessionsDb(tableName: setsTableName, id: id);
  }

  removeSetWeight(id) {
    _removeFromSessionsDb(tableName: setsWeightTableName, id: id);
  }

  insertExerciseSession(Map<String, Object> data) async {
    _insertInSessionsDb(tableName: exerciseSessionsTableName, data: data);
  }

  insertSet(Map<String, Object> setData, Map<String, Object> weightData) async {
    _insertInSessionsDb(tableName: setsTableName, data: setData);
    if (weightData != null) _insertInSessionsDb(tableName: setsWeightTableName, data: weightData);
  }

  _insertInSessionsDb({String tableName, Map<String, Object> data}) async {
    final sqlDb = await _getSessionsDB();
    sqlDb.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
    
    var table = await sqlDb.query(tableName);
    print('Added ${data['id']} to $tableName:');
    print(table);
  }

  _removeFromSessionsDb({String tableName, String id}) async {
    final sqlDb = await _getSessionsDB();
    sqlDb.execute('DELETE FROM $tableName WHERE id = \'${id.toString()}\'');
    var table = await sqlDb.query(tableName);
    print('Removed $id from $tableName');
    print(table);
  }

  _removeExerciseSessionByWorkoutSessionLink({String workoutSessionId, BuildContext context}) async{
    List<ExerciseSession> exSesIds = Provider.of<ExerciseSessionsProvider>(context).filterSessionsByWorkoutSession(workoutSessionId: workoutSessionId);
    final sqlDb = await _getSessionsDB();
    sqlDb.execute('DELETE FROM $exerciseSessionsTableName WHERE workout_id = \'$workoutSessionId\'');
    exSesIds.forEach((id) => sqlDb.execute('DELETE FROM $setsTableName WHERE exercise_session_id = \'$id\''));
  }

  _loadTableData(String table) async {
    final sqlDb = await _getSessionsDB();
    return await sqlDb.query(table);
  }

  _loadSets({data, weights}) {
    List<Set> sets = [];

    data.forEach((setData) {
      var weightData;
      SetWeight setWeight;

      try {
        weightData = weights
            .firstWhere((weight) => weight['id'] == setData['weight_id']);
        setWeight = new SetWeight(
          id: weightData['id'],
          kg: weightData['kg'],
        );
      } catch (error) {}

      sets.add(
        new Set(
          id: setData['id'],
          exerciseSessionId: setData['exercise_session_id'],
          reps: setData['reps'],
          weightUsed: setWeight,
        ),
      );
    });

    return sets;
  }

  _loadExerciseSessions({
    data,
    SetsProvider sets,
    WorkoutSessionsProvider workoutSessions,
    ExercisesProvider exercises,
  }) {
    List<ExerciseSession> sessions = [];

    data.forEach((session) {
      List<Set> relevantSets =
          sets.filterByExerciseSession(sessionId: session['id']);

      sessions.add(
        new ExerciseSession(
          id: session['id'],
          exercise: exercises.getExerciseById(session['exercise_id']),
          workoutSessionId: session['workout_id'],
          durationInMillisec: session['millisecs_duration'],
          sets: relevantSets,
          note: session['note'],
        ),
      );
    });

    return sessions;
  }

  _loadWorkoutSession({
    data,
    ExerciseSessionsProvider exerciseSessions,
    WorkoutSessionsProvider workoutSessions,
    WorkoutsProvider workouts,
  }) {
    List<WorkoutSession> sessions = [];

    data.forEach((session) {
      List<ExerciseSession> relevantExerciseSessions = exerciseSessions
          .filterSessionsByWorkoutSession(workoutSessionId: session['id']);

      var newWorkoutSession = new WorkoutSession(
        id: session['id'],
        sessionWorkout: workouts.getWorkoutById(session['session_workout_id']),
        date:
            (session['date'] != null) ? DateTime.parse(session['date']) : null,
        durationInMillisec: session['millisecs_duration'],
        exerciseSessions: relevantExerciseSessions,
      );

      sessions.add(newWorkoutSession);
      exerciseSessions.setWorkoutSession(workoutSessionId: session['id'], workoutSession: newWorkoutSession);
    });

    workoutSessions.setLoadedFromDB(true);
    return sessions;
  }

  loadSessionsData({
    @required BuildContext context,
    @required SetsProvider sets,
    @required ExerciseSessionsProvider exerciseSessions,
    @required ExercisesProvider exercises,
    @required WorkoutsProvider workouts,
    @required WorkoutSessionsProvider workoutSessions,
  }) async {
    //TODO: Finish
    //1. load set weights.
    var setsWeightData = await _loadTableData(setsWeightTableName);

    //2. load sets.
    var setsData = await _loadTableData(setsTableName);
    if (sets.setsList.isEmpty)
      sets.setSets(sets: _loadSets(data: setsData, weights: setsWeightData));

    //3. load exerciseSessions.
    var exerciseSessionsData = await _loadTableData(exerciseSessionsTableName);
    if (exerciseSessions.sessionsList.isEmpty) {
      exerciseSessions.setSessionsList(
        newSessionsList: _loadExerciseSessions(
          data: exerciseSessionsData,
          sets: sets,
          workoutSessions: workoutSessions,
          exercises: exercises,
        ),
      );
    }
    //4. load workoutSessions.
    var workoutSessionsData = await _loadTableData(workoutSessionsTableName);
    if (workoutSessions.sessionsList.isEmpty)
      workoutSessions.setSessionsList(
        newSessionsList: _loadWorkoutSession(
          data: workoutSessionsData,
          exerciseSessions: exerciseSessions,
          workoutSessions: workoutSessions,
          workouts: workouts,
        ),
      );
  }

  ////////////////////////////////////// DATA INITIALIZER
  loadSavedData(context) async {
    var userProvider = Provider.of<UserProvider>(context);
    var workoutsProvider = Provider.of<WorkoutsProvider>(context);
    var exercisesProvider = Provider.of<ExercisesProvider>(context);
    var setsProvider = Provider.of<SetsProvider>(context);
    var exerciseSessionsProvider =
        Provider.of<ExerciseSessionsProvider>(context);
    var workoutSessionsProvider = Provider.of<WorkoutSessionsProvider>(context);
    
    if (userProvider.id == null) {
      await getUser(context, userProvider);
      await getWeightsList(
          context, userProvider); //will be stored in the user provider
      await getExercisesList(context, exercisesProvider);
      await getWorkoutsList(context, workoutsProvider);

      await loadSessionsData(
        context: context,
        exerciseSessions: exerciseSessionsProvider,
        exercises: exercisesProvider,
        workoutSessions: workoutSessionsProvider,
        sets: setsProvider,
        workouts: workoutsProvider,
      );
    }
    return {
      'user': userProvider,
      'workouts': workoutsProvider,
      'exercises': exercisesProvider,
      'sessions': {
        'sets': setsProvider,
        'exerciseSessions': exerciseSessionsProvider,
        'workoutSessions': workoutSessionsProvider
      }
    };
  }
}
