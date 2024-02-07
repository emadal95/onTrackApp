import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/customs/title_with_card.dart';
import 'package:gym_tracker/widgets/statistics/exercise_stats_card.dart';
import 'package:gym_tracker/widgets/statistics/exercise_time_progress_card.dart';
import 'package:gym_tracker/widgets/statistics/exercise_week_days_distribution_card.dart';
import 'package:gym_tracker/widgets/statistics/weight_progress_card.dart';

class ExerciseStatsCardsDeck extends StatefulWidget {
  ExerciseStatsCardsDeck();

  @override
  _ExerciseStatsCardsDeckState createState() => _ExerciseStatsCardsDeckState();
}

class _ExerciseStatsCardsDeckState extends State<ExerciseStatsCardsDeck> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWithCard(
          WeightProgressCard(),
          title: 'Lifting Progress',
          subtitle: 'Weight lifting progress over time. ' +
              'The weight value for one exercise session equals the average ' +
              'of the weights used for each set of that specific exercise session.',
        ),
        TitleWithCard(
          ExerciseTimeProgressCard(),
          title: 'Time Progress',
          subtitle: 'Recorded duration of exercise sessions over time.',
        ),
        TitleWithCard(
          ExerciseWeekDaysDistributionCard(),
          title: 'Weekly Distribution',
          subtitle:
              'Displays the distribution of one exercise throughtout week days. ' +
              'Each bar represents the total amount of times the exercise was performed on a specific week day.',
        ),
        TitleWithCard(
          ExerciseStatsCard(),
          title: 'Summary',
          subtitle: 'Counts and averages relevant to exercises.'
        )
      ],
    );
  }
}
