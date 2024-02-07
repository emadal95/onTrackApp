import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/workout_icons.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/exercise_session.dart';

class ExerciseSessionSmallCard extends StatelessWidget {
  TextStyle bodyTextStyle;
  BuildContext context;
  ExerciseSession session;
  ExerciseSessionSmallCard(this.session);

  String _formatDuration() {
    var duration = Duration(milliseconds: session.durationInMillisec);
    return (duration.inMinutes > 0)
        ? '${duration.inMinutes} min'
        : '${duration.inSeconds} s';
  }

  String _formatWeight() {
    List<double> weights = (session.sets.length > 0)
        ? session.sets
            .where((_set) => _set.weightUsed != null)
            .toList()
            .map((_set) =>
                Weight.getWeightInUserUnits(_set.weightUsed.weight, context))
            .toList()
        : [];
    var weightsAvg = (weights.length > 0)
        ? (weights.reduce((sum, weight) => sum + weight) / weights.length)
        : 0;

    return '${weightsAvg.toStringAsFixed(0)} ${Unit.mapToStr(Provider.of<UserProvider>(context).weightUnit)}';
  }

  Widget _buildInfoEntry({IconData icon, String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 4),
        AutoSizeText(
          '$label',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 4,
          maxFontSize: 10,
          textAlign: TextAlign.center,
          style: bodyTextStyle,
        ),
      ],
    );
  }

  Widget _buildSetsNumRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: Center(
            child: AutoSizeText(
              '${session.sets.length}',
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              minFontSize: 4,
              maxFontSize: 8,
            ),
          ),
        ),
        SizedBox(width: 4),
        AutoSizeText(
          'sets',
          maxLines: 1,
          minFontSize: 4,
          maxFontSize: 10,
          textAlign: TextAlign.center,
          style: bodyTextStyle,
        ),
      ],
    );
  }

  Widget _buildSpecsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildSetsNumRow(),
        (session.durationInMillisec != null)
            ? _buildInfoEntry(icon: Icons.timer, label: '${_formatDuration()}')
            : SizedBox(),
        _buildInfoEntry(
            icon: WorkoutIcons.dumbbell, label: '${_formatWeight()}'),
      ],
    );
  }

  Widget _buildRepText(int rep) {
    return Center(
      child: AutoSizeText(
        '${rep} rep${(rep > 1) ? 's' : ''}',
        minFontSize: 4,
        maxFontSize: 10,
        style: bodyTextStyle,
      ),
    );
  }

  Widget _buildRepsSlide() {
    var reps = session.sets
        .where((_set) => _set.reps != null)
        .toList()
        .map((_set) => _set.reps)
        .toList();

    return (reps.length > 0)
        ? Container(
            //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            height: 30,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 6),
              shrinkWrap: true,
              itemCount: reps.length,
              itemBuilder: (ctx, i) => _buildRepText(reps[i]),
              separatorBuilder: (ctx, i) => VerticalDivider(
                indent: 4,
                endIndent: 4,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : SizedBox();
  }

  Widget get exerciseIcon {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Icon(
        session.exercise.icon,
      ),
    );
  }

  Widget get cardTitle {
    return AutoSizeText(
      '${session.exercise.name}',
      maxLines: 1,
      minFontSize: 15,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this.bodyTextStyle = TextStyle(color: Theme.of(context).primaryColor);

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          exerciseIcon,
          cardTitle,
          _buildSpecsRow(),
          _buildRepsSlide()
        ],
      ),
    );
  }
}