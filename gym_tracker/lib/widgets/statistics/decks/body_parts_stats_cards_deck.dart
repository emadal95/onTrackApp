import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/customs/title_with_card.dart';
import 'package:gym_tracker/widgets/statistics/body_parts_focus_card.dart';
import 'package:gym_tracker/widgets/statistics/body_parts_week_days_distribution_card.dart';

class BodyPartsStatsCardsDeck extends StatefulWidget {
  BodyPartsStatsCardsDeck();

  @override
  _BodyPartsStatsCardsDeckState createState() =>
      _BodyPartsStatsCardsDeckState();
}

class _BodyPartsStatsCardsDeckState extends State<BodyPartsStatsCardsDeck> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWithCard(
          BodyPartsFocusCard(),
          title: 'Targets Focus',
          subtitle: 'Count of times each body part was targeted during the selected time interval.',
        ),
        TitleWithCard(
          BodyPartsWeekDistributionCard(),
          title: 'Weekly Distribution',
          subtitle: 'Displays the distribution of targets throughtout week days. ' +
                'Each bar represents the amount of times the selected body part was targeted during the selected time interval. ' +
                '\'Week\' will show targets from current week only.',
        )
      ],
    );
  }
}
