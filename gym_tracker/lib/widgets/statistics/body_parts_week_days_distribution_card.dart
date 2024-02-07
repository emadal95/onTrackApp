import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/week.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/widgets/body_parts/body_part_picker.dart';
import 'package:gym_tracker/widgets/body_parts/body_parts_dropdown.dart';
import 'package:gym_tracker/widgets/charts_widgets/bar_charts/body_parts_per_week_day_chart.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/customs/time_period_chips.dart';
import 'package:provider/provider.dart';

class BodyPartsWeekDistributionCard extends StatefulWidget {
  BodyPartsWeekDistributionCard();

  @override
  _BodyPartsWeekDistributionCardState createState() =>
      _BodyPartsWeekDistributionCardState();
}

class _BodyPartsWeekDistributionCardState
    extends State<BodyPartsWeekDistributionCard> {
  BODYPARTS target;
  TIMEPERIODS period;

  @override
  void initState() {
    super.initState();
    period = TIMEPERIODS.week;
  }

  void _onTargetSelected(BODYPARTS newTarget) {
    setState(() {
      target = newTarget;
    });
  }

  void _onPeriodChanged(TIMEPERIODS newPeriod) {
    setState(() {
      period = newPeriod;
    });
  }

  Widget get header {
    List<BODYPARTS> relevantTargets = [];
    Provider.of<ExerciseSessionsProvider>(context)
        .getExerciseOfSessionsWithBodyPartsOnly()
        .forEach((exercise) => relevantTargets.addAll(exercise.bodyParts));

    relevantTargets = relevantTargets.toSet().toList();
    relevantTargets.removeWhere((target) => target == BODYPARTS.ALL);

    if (relevantTargets.length > 0 && target == null)
      target = relevantTargets[0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 4,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
            ),
            alignment: Alignment.centerLeft,
            child: BodyPartsDropdown(
              onPartSelected: _onTargetSelected,
              partsToDisplay: relevantTargets,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Flexible(
          flex: 2,
          child: TimePeriodChips(
            onPeriodSelected: _onPeriodChanged,
            initialSelection: this.period,
          ),
        )
      ],
    );
  }

  Widget get graph {
    return Container(
      //color: Colors.blue,
      width: double.infinity,
      alignment: Alignment.center,
      child: BodyPartsPerWeekdayChart(
        context: context,
        sessionData: relevantSessions,
      ),
    );
  }

  List<ExerciseSession> get relevantSessions {

    var relevantSessions = Provider.of<ExerciseSessionsProvider>(context)
        .getSessionsWithBodyPartsOnly()
        .cast<ExerciseSession>();
    if (relevantSessions == null) relevantSessions = [];

    relevantSessions = relevantSessions
        .where((ExerciseSession session) =>
            session.exercise.bodyParts.contains(this.target))
        .toList();

    List<DateTime> weekDates = Week.datesOfCurrentWeek();

    relevantSessions = (this.period == TIMEPERIODS.week)
        ? relevantSessions
            .where(
              (ExerciseSession session) => weekDates.any((weekDay) => weekDay.difference(session.workoutSession.date).inDays == 0),
            )
            .toList()
        : relevantSessions;

    return relevantSessions;
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    CardWithHeader(
      header: header,
      child: graph,
      height: 300,
    );
  }
}
