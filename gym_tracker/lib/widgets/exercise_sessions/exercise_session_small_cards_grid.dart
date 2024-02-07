import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/widgets/exercise_sessions/exercise_session_small_card.dart';

class ExerciseSessionSmallCardsGrid extends StatelessWidget {
  BuildContext context;
  List<ExerciseSession> exerciseSessions;

  ExerciseSessionSmallCardsGrid(this.exerciseSessions);

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Container(
      width: double.infinity,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        //padding: EdgeInsets.all(20),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, i) => ExerciseSessionSmallCard(exerciseSessions[i]),
        itemCount: exerciseSessions.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
