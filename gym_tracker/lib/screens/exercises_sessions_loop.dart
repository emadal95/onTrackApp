import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/sets_provider.dart';
import 'package:gym_tracker/widgets/exercise_sessions/exercise_session_logs.dart';
import 'package:gym_tracker/widgets/exercises/exercise_small_card.dart';
import 'package:gym_tracker/widgets/customs/floating_page.dart';
import 'package:gym_tracker/widgets/timer/timer_controller.dart';
import 'package:provider/provider.dart';

class ExerciseSessionLoop extends StatefulWidget {
  final Exercise exercise;
  final WorkoutSession workoutSession;
  Function onCompleted;
  final Color color;
  ExerciseSessionLoop(
      {this.exercise, this.color, @required this.workoutSession, this.onCompleted});

  _ExerciseSessionLoopState createState() => _ExerciseSessionLoopState();
}

class _ExerciseSessionLoopState extends State<ExerciseSessionLoop> {
  Dependencies dependencies = new Dependencies();
  ExerciseSession exerciseSession;
  ExerciseSessionLogs exerciseSessionLogs;

  @override
  void initState() {
    exerciseSession = new ExerciseSession(
      id: UniqueKey().toString(),
      exercise: widget.exercise,
      workoutSession: widget.workoutSession,
      workoutSessionId: widget.workoutSession.id,
    );
    super.initState();
  }

  void _onResetExerciseSessionTimer() {
    setState(() {
      dependencies.stopwatch.stop();
      dependencies.stopwatch.reset();
    });
  }

  void _onStartExerciseSessionTimer() {
    setState(() {
      dependencies.stopwatch.start();
    });
  }

  void _onPauseExerciseSessionTimer() {
    setState(() {
      dependencies.stopwatch.stop();
    });
  }

  void _saveSets() {
    exerciseSession.setSets(exerciseSessionLogs.newSets);
    exerciseSession.sets.forEach((_set) {
      Provider.of<SetsProvider>(context).addSet(newSet: _set);
      AppDatabase().insertSet(
        QueryHelper.toQuerySetData(_set),
        (_set.weightUsed != null)
            ? QueryHelper.toQuerySetWeightData(_set.weightUsed)
            : null,
      );
    });
  }

  void _saveSession() {
    Provider.of<ExerciseSessionsProvider>(context)
        .insertSession(newSession: exerciseSession);
    AppDatabase().insertExerciseSession(
        QueryHelper.toQueryExerciseSessionData(exerciseSession));
  }

  void _recordDuration() {
    exerciseSession.durationInMillisec = dependencies.stopwatch.elapsedMilliseconds;
  }

  void _onSaveExerciseSession() {
    _recordDuration();
    _saveSets();
    _saveSession();
    widget.onCompleted(exerciseSession);
    Navigator.pop(context);
  }

  Widget _buildTimerToolBtn({Function onTap, IconData icon, Color color}) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Icon(
          icon,
          size: 60,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimerToolBar({IconData icon, Function onTap, Color color}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildTimerToolBtn(
            icon: Icons.refresh,
            color: Colors.white,
            onTap: _onResetExerciseSessionTimer,
          ),
          _buildTimerToolBtn(
            icon: Icons.pause_circle_filled,
            color: (dependencies.stopwatch.isRunning)
                ? Colors.amberAccent
                : Colors.grey,
            onTap: (dependencies.stopwatch.isRunning)
                ? _onPauseExerciseSessionTimer
                : null,
          ),
          _buildTimerToolBtn(
            icon: Icons.play_circle_filled,
            color: (!dependencies.stopwatch.isRunning)
                ? Colors.greenAccent
                : Colors.grey,
            onTap: (dependencies.stopwatch.isRunning)
                ? null
                : _onStartExerciseSessionTimer,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTimerCard() {
    return Container(
      width: double.infinity,
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: widget.color,
        margin: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AutoSizeText(
              'Start your exercise session',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Container(
              child: TimerText(
                dependencies: dependencies,
                small: true,
              ),
            ),
            _buildTimerToolBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSpecsCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ExerciseSmallCard(
        exercise: widget.exercise,
        descriptionMaxLines: 100,
      ),
    );
  }

  Widget _buildExerciseSessionColumn() {
    this.exerciseSessionLogs = ExerciseSessionLogs(
      exerciseSession: exerciseSession,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: <Widget>[
          _buildExerciseSpecsCard(),
          _buildSmallTimerCard(),
          this.exerciseSessionLogs
        ],
      ),
    );
  }

  List<Widget> get pageActions {
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        color: Colors.redAccent,
        onPressed: () => Navigator.of(context).pop(),
      ),
      IconButton(
        icon: Icon(Icons.check_circle),
        color: Colors.greenAccent,
        onPressed: _onSaveExerciseSession,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    dependencies.setTextStyle(
      TextStyle(fontSize: 35, color: Colors.white),
    );

    return FloatingPage(
      actions: <Widget>[...pageActions],
      child: Column(
        children: <Widget>[
          Divider(
            height: 1,
            color: Theme.of(context).primaryColor,
            thickness: 1,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _buildExerciseSessionColumn(),
              ),
            ),
          ),
        ],
      ),
      title: 'Exercise Session',
    );
  }
}
