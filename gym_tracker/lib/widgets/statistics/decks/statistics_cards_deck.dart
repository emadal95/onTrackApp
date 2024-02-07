import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/widgets/statistics/body_parts_focus_card.dart';
import 'package:gym_tracker/widgets/statistics/decks/body_parts_stats_cards_deck.dart';
import 'package:gym_tracker/widgets/statistics/decks/exercises_stats_cards_deck.dart';
import 'package:gym_tracker/widgets/statistics/decks/workout_stats_cards_deck.dart';
import 'package:gym_tracker/widgets/statistics/exercise_stats_card.dart';
import 'package:gym_tracker/widgets/statistics/exercise_time_progress_card.dart';
import 'package:gym_tracker/widgets/statistics/exercise_week_days_distribution_card.dart';
import 'package:gym_tracker/widgets/statistics/weight_progress_card.dart';
import 'package:provider/provider.dart';

enum STATS_CATEGORY {
  EXERCISE_SESSIONS,
  WORKOUT_SESSIONS,
  TARGET_BODY,
  ALL //for testing
}

class StatsCategoryDescription{
  STATS_CATEGORY category;
  StatsCategoryDescription(this.category);

  String get description {
    switch(category){
      case STATS_CATEGORY.EXERCISE_SESSIONS:
        return 'Exercise focused stats';
      case STATS_CATEGORY.WORKOUT_SESSIONS:
        return 'Workout focused stats';
      case STATS_CATEGORY.TARGET_BODY:
        return 'Body parts stats';
      default:
        return '';
    }
  }
}

class StatisticsCardsDeck extends StatefulWidget {
  StatisticsCardsDeck();

  @override
  _StatisticsCardsDeckState createState() => _StatisticsCardsDeckState();
}

class _StatisticsCardsDeckState extends State<StatisticsCardsDeck> {
  UserProvider user;
  final double pageHeaderHeightFactor = (1 / 3.5);
  WorkoutSessionsProvider workoutSessions;
  ExerciseSessionsProvider exerciseSessions;
  STATS_CATEGORY category;

  @override
  @override
  void initState() {
    super.initState();
    category = STATS_CATEGORY.EXERCISE_SESSIONS;
  }

  onCategoryChanged(newCat) {
    setState(() {
      this.category = newCat;
    });
  }

  Widget _buildPageTitle(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.contain,
        child: AutoSizeText(
          'Stats',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 100),
        ),
      ),
    );
  }

  Widget _buildPageTools(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FittedBox(fit: BoxFit.contain, child: _buildToolsRow(context)),
    );
  }

  Widget _buildFlatBtn(BuildContext context, STATS_CATEGORY cat, {String title, Function onPressed}) {
    return Tooltip(
      message: StatsCategoryDescription(cat).description,
      child: Container(
        decoration: (category == cat)
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).accentColor,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: FlatButton(
          //padding: EdgeInsets.all(0),
          onPressed: () => onPressed(cat),
          child: AutoSizeText(
            title,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget _buildToolsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildFlatBtn(context, STATS_CATEGORY.WORKOUT_SESSIONS,
            title: 'By Workout', onPressed: onCategoryChanged),
        _buildFlatBtn(context, STATS_CATEGORY.EXERCISE_SESSIONS,
            title: 'By Exercise', onPressed: onCategoryChanged),
        _buildFlatBtn(context, STATS_CATEGORY.TARGET_BODY,
            title: 'By Target', onPressed: onCategoryChanged)
      ],
    );
  }

  Widget _buildPageHeader(BuildContext context) {
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
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(flex: 1, child: _buildPageTitle(context)),
          SizedBox(
            width: 20,
          ),
          Flexible(flex: 2, child: _buildPageTools(context))
        ],
      ),
    );
  }

  _buildScrollView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 36),
      child: Column(
        children: <Widget>[
          if (category == STATS_CATEGORY.EXERCISE_SESSIONS) ExerciseStatsCardsDeck(),
          if (category == STATS_CATEGORY.TARGET_BODY) BodyPartsStatsCardsDeck(),
          if (category == STATS_CATEGORY.WORKOUT_SESSIONS) WorkoutStatsCardsDeck(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = (user == null) ? Provider.of<UserProvider>(context) : user;
    workoutSessions = (workoutSessions == null)
        ? Provider.of<WorkoutSessionsProvider>(context)
        : workoutSessions;
    exerciseSessions = (exerciseSessions == null)
        ? Provider.of<ExerciseSessionsProvider>(context)
        : exerciseSessions;

    return Column(
      children: [
        _buildPageHeader(context),
        Expanded(child: _buildScrollView()),
      ],
    );
  }
}
