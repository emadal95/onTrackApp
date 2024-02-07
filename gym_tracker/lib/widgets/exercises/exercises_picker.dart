import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/body_icons.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/widgets/exercises/exercise_quick_add.dart';
import 'package:gym_tracker/widgets/exercises/new_exercise_form.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ExercisesPicker extends StatefulWidget {
  final double cardBorderRadius = 12;
  Function listener;
  List<String> pickedExercisesId;

  ExercisesPicker(this.listener, this.pickedExercisesId);

  _ExercisesPickerState createState() => _ExercisesPickerState();
}

class _ExercisesPickerState extends State<ExercisesPicker> {
  ExercisesProvider exercises;

  Widget _buildHeaderTile(Exercise exercise, id) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        child: Icon(
          exercise.icon,
          color: Colors.white
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      title: AutoSizeText(
        exercise.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: AutoSizeText(
        (exercise.about != null && exercise.about.isNotEmpty)
            ? exercise.about
            : 'No description. Press and hold to edit',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSpecsCircle(
      {Color color, IconData icon, double percent, double iconSize}) {
    return CircularPercentIndicator(
      radius: 18,
      progressColor: color,
      percent: percent,
      center: Icon(
        icon,
        size: iconSize,
      ),
      lineWidth: 2,
    );
  }

  List<Widget> _buildBodyPartCircles(Exercise exercise, String id) {
    List<Widget> bodyCircles = [];
    if (exercise.bodyParts == null) {
      return [
        _buildSpecsCircle(
            color: (!widget.pickedExercisesId.contains(id))
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            icon: HumanBody.mapToIcon(null),
            percent: 1.0,
            iconSize: 10)
      ];
    } else {
      for (int b_i = 0; b_i < exercise.bodyParts.length; b_i++) {
        if (b_i < 3) {
          bodyCircles.add(
            _buildSpecsCircle(
                color: (!widget.pickedExercisesId.contains(id))
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                icon: (exercise.bodyParts != null)
                    ? HumanBody.mapToIcon(exercise.bodyParts[b_i])
                    : HumanBody.mapToIcon(null),
                percent: 1.0,
                iconSize: 10),
          );
          if (b_i != 2 && b_i != exercise.bodyParts.length - 1)
            bodyCircles.add(SizedBox(
              width: 20,
            ));
        }
      }
    }

    return bodyCircles;
  }

  Widget _buildSpecsRow(Exercise exercise, String id) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerRight,
      child: (exercise.bodyParts.length > 0)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _buildSpecsCircle(
                    color: Intensity.mapToColor(exercise.level),
                    icon: ChartIcons.chart_bar_2,
                    percent: Intensity.mapToIntensityPercentage(exercise.level),
                    iconSize: 10),
                SizedBox(
                  width: 20,
                ),
                ..._buildBodyPartCircles(exercise, id)
              ],
            )
          : _buildSpecsCircle(
              color: Intensity.mapToColor(exercise.level),
              icon: ChartIcons.chart_bar_2,
              percent: Intensity.mapToIntensityPercentage(exercise.level),
              iconSize: 10),
    );
  }

  void editExercise(Exercise ex) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).backgroundColor,
      context: context,
      builder: (ctx) => ExerciseQuickAdd(
        editMode: true,
        exerciseToLoad: ex,
      ),
      isDismissible: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      elevation: 25,
    );
  }

  Widget _buildExerciseSpecsCard(exercise, id) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.cardBorderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.cardBorderRadius),
        onTap: () => widget.listener(id),
        onLongPress: () => editExercise(exercise),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.cardBorderRadius),
            border: Border.all(
              color: (widget.pickedExercisesId.contains(id))
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: <Widget>[
              _buildHeaderTile(exercise, id),
              _buildSpecsRow(exercise, id),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    exercises = Provider.of<ExercisesProvider>(context);

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) => _buildExerciseSpecsCard(
                exercises.exercisesList[exercises.exercisesList.length - 1 - i],
                exercises
                    .exercisesList[exercises.exercisesList.length - 1 - i].id),
            itemCount: exercises.exercisesList.length,
          ),
        ),
      ],
    );
  }
}
