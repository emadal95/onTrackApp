import 'dart:async';
import 'package:animator/animator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/sets_provider.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/widgets/customs/dialogs.dart';
import 'package:gym_tracker/widgets/exercises/exercises_small_cards_grid.dart';
import 'package:gym_tracker/widgets/timer/timer_card.dart';
import 'package:gym_tracker/widgets/timer/timer_controller.dart';
import 'package:gym_tracker/widgets/workouts/workouts_grid.dart';
import 'package:provider/provider.dart';

class NewSessionScreen extends StatefulWidget {
  @override
  _NewSessionScreenState createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends State<NewSessionScreen> {
  ScrollController _viewScrollController = ScrollController();
  Dependencies watch = new Dependencies();
  final Color _PRIMARY_COLOR = Colors.black87.withOpacity(0.8);
  final double pageHeaderHeightFactor = (1 / 3.5);
  WorkoutSession newWorkoutSession;
  WorkoutsProvider workouts;
  String _selectedWorkoutId;
  List<String> performedExercisesIds = [];
  bool inSession = false;

  void _onWrokoutSelected({String workoutId}) {
    setState(() {
      _scrollToTop();
      _selectedWorkoutId = workoutId;
      newWorkoutSession = new WorkoutSession(
        id: UniqueKey().toString(),
        sessionWorkout: workouts.getWorkoutById(workoutId),
        date: DateTime.now(),
      );
    });
  }

  void clearSessionData() {
    _selectedWorkoutId = null;
    inSession = false;
    watch = new Dependencies();
    performedExercisesIds = [];
  }

  void pauseWatch() {
    watch.stopwatch.stop();
  }

  void resetWatch() {
    watch.stopwatch.stop();
    watch.stopwatch.reset();
  }

  void startWatch() {
    setState(() {
      watch.stopwatch.start();
      inSession = true;
    });

    _scrollToBottom();
  }

  int get ellapsedMillisecs {
    return watch.stopwatch.elapsedMilliseconds;
  }

  void _onSaveSession() {
    pauseWatch();
    print(ellapsedMillisecs);
    newWorkoutSession.setDuration(ellapsedMillisecs);
    setState(() {
      Provider.of<WorkoutSessionsProvider>(context)
          .insertSession(newSession: newWorkoutSession);
      AppDatabase().insertWorkoutSession(
          QueryHelper.toQueryWorkoutSessionData(newWorkoutSession));
      clearSessionData();
    });
    Navigator.of(context).pop();
  }

  void _deleteSavedProgress() {
    Provider.of<ExerciseSessionsProvider>(context).removeExerciseSessions(
        sessionsIds: performedExercisesIds, context: context);
  }

  void _onQuitSession() {
    setState(() {
      _deleteSavedProgress();
      clearSessionData();
    });
    Navigator.of(context).pop();
  }

  void _onExerciseCompleted(ExerciseSession completedExercise) {
    setState(() {
      if (!performedExercisesIds.contains(completedExercise.exercise.id)) {
        performedExercisesIds.add(completedExercise.exercise.id);
        newWorkoutSession.addExerciseSession(completedExercise);
      }
    });
  }

  void _onEndSession() async {
    await Dialogs(context).onSaveSessionDialog(onSave: _onSaveSession);
  }

  void _onCancelSession() async {
    if (inSession) {
      await Dialogs(context).onCancelSessionDialog(onQuit: _onQuitSession);
    } else {
      setState(() {
        clearSessionData();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(
      Duration(milliseconds: 150),
      () => _viewScrollController.animateTo(
        _viewScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      ),
    );
  }

  void _scrollToTop() {
    _viewScrollController.animateTo(
        _viewScrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.linear);
  }

  Widget _buildPageTitle() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: AutoSizeText(
          'New Session',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 100),
        ),
      ),
    );
  }

  Widget _buildPageTools() {
    return Container(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          children: <Widget>[
            (_selectedWorkoutId != null)
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                    ),
                    onPressed: _onCancelSession,
                  )
                : SizedBox(
                    width: 1,
                    height: 1,
                  ),
            (inSession)
                ? IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    ),
                    onPressed: _onEndSession,
                  )
                : SizedBox(
                    height: 1,
                    width: 1,
                  ),
            (_selectedWorkoutId == null)
                ? _buildStepTitle(title: 'Select Workout')
                : SizedBox(height: 1, width: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: MediaQuery.of(context).size.width * pageHeaderHeightFactor,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(flex: 2, child: _buildPageTitle()),
          Flexible(flex: 1, child: _buildPageTools())
        ],
      ),
    );
  }

  Widget _buildStepTitle({String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: AutoSizeText(
        title,
        style:
            Theme.of(context).textTheme.caption.copyWith(color: _PRIMARY_COLOR),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildWorkoutsGrid() {
    return WorkoutsGrid(
      borderColor: _PRIMARY_COLOR,
      onWorkoutSelected: _onWrokoutSelected,
    );
  }

  Widget _buildTimerCard() {
    return Animator(
      duration: Duration(milliseconds: 150),
      repeats: 1,
      tween: Tween<double>(begin: -100, end: 0),
      builder: (animation) => Transform.translate(
        offset: Offset(animation.value, 0),
        child: TimerCard(
          title: 'Start your workout session',
          color: _PRIMARY_COLOR,
          onStartTimer: startWatch,
          onResetTimer: resetWatch,
          onPauseTimer: pauseWatch,
          watchDependencies: watch,
        ),
      ),
    );
  }

  Widget _buildExercisesGrid() {
    Workout workout = workouts.getWorkoutById(_selectedWorkoutId);

    return (workout.exercises.length > 0)
        ? Animator(
            tween: Tween<double>(begin: 100, end: 0),
            repeats: 1,
            duration: Duration(milliseconds: 200),
            builder: (anim) => Transform.translate(
              offset: Offset(0, anim.value),
              child: ExerciseSmallCardsGrid(
                parentWorkout: workout,
                workoutSession: newWorkoutSession,
                onExerciseSessionCompleted: _onExerciseCompleted,
                pickedExercisesIds: performedExercisesIds,
                primaryColor: _PRIMARY_COLOR,
              ),
            ),
          )
        : Container(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Text(
                'This workout has no exercises.',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          );
  }

  _buildScrollView() {
    return SingleChildScrollView(
      controller: _viewScrollController,
      padding: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          (_selectedWorkoutId == null) ? _buildWorkoutsGrid() : SizedBox(),
          (_selectedWorkoutId != null) ? _buildTimerCard() : Text(''),
          (_selectedWorkoutId != null && inSession)
              ? _buildExercisesGrid()
              : Text(''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    workouts = Provider.of<WorkoutsProvider>(context);
    if (_selectedWorkoutId != null)
      _viewScrollController = new ScrollController(
        initialScrollOffset: _viewScrollController.position.maxScrollExtent,
      );

    return Column(
      children: [
        _buildPageHeader(),
        Expanded(child: _buildScrollView()),
      ],
    );
  }
}
