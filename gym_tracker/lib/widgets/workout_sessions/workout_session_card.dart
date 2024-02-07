import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/widgets/exercise_sessions/exercise_session_small_cards_grid.dart';
import 'package:intl/intl.dart';

class WorkoutSessionCard extends StatelessWidget {
  BuildContext context;
  WorkoutSession workoutSession;

  WorkoutSessionCard({this.workoutSession});

  Widget _buildHeader() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      title: AutoSizeText(
        '${workoutSession.sessionWorkout.name}',
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 30),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: (workoutSession.date != null)
          ? AutoSizeText('${DateFormat.yMMMd().format(workoutSession.date)}')
          : null,
      trailing: Icon(
        workoutSession.sessionWorkout.icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  String _formatDuration() {
    var duration = Duration(milliseconds: workoutSession.durationInMillisec);
    return (duration.inMinutes > 0)
        ? '${duration.inMinutes} min'
        : '${duration.inSeconds} sec';
  }

  Widget _buildWorkoutSessionDurationEntry() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.timer,
          size: 22,
        ),
        SizedBox(
          width: 6,
        ),
        AutoSizeText(
          '${_formatDuration()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildWorkoutSessionIntensityEntry() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          ChartIcons.chart_bar_2,
          size: 22,
        ),
        SizedBox(
          width: 6,
        ),
        AutoSizeText(
          '${Intensity.mapToString(workoutSession.sessionWorkout.level)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSessionInfoTile() {
    return Container(
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (workoutSession.durationInMillisec != null)
              ? _buildWorkoutSessionDurationEntry()
              : SizedBox(),
          _buildWorkoutSessionIntensityEntry(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Container(
      child: Container(
        //height: 200,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(),
                Divider(thickness: .5, color: Theme.of(context).primaryColor),
                _buildSessionInfoTile(),
                if(workoutSession.exerciseSessions.length > 0) ExerciseSessionSmallCardsGrid(workoutSession.exerciseSessions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
