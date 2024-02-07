import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/screens/exercise_creation_screen.dart';
import 'package:gym_tracker/widgets/body_parts/body_parts_icons_grid.dart';
import 'package:gym_tracker/widgets/customs/dialogs.dart';
import 'package:gym_tracker/widgets/customs/dismissible_background.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CustomExercisesScreen extends StatefulWidget {
  static final String routeName = '/customExercises';

  _CustomExercisesScreenState createState() => _CustomExercisesScreenState();
}

class _CustomExercisesScreenState extends State<CustomExercisesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ExercisesProvider exercises;

  void _addNewExercise() {
    scaffoldKey.currentState.showBottomSheet(
      (ctx) => ExerciseCreationScreen(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        side: BorderSide(width: 0.5, color: Colors.black87.withOpacity(0.2)),
      ),
      elevation: 20,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  void _removeExercise(String id) {
    exercises.removeExercise(id, context);
  }

  void _editExercise(String id) {
    scaffoldKey.currentState.showBottomSheet(
      (ctx) => ExerciseCreationScreen(
        editMode: true,
        idForEdit: id,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        side: BorderSide(width: 0.5, color: Colors.black87.withOpacity(0.2)),
      ),
      elevation: 20,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildIconCircle(Exercise exercise) {
    return CircularPercentIndicator(
      percent: Intensity.mapToIntensityPercentage(exercise.level),
      radius: 90,
      animation: true,
      animationDuration: 2000,
      lineWidth: 3,
      progressColor: Intensity.mapToColor(exercise.level),
      center: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 40,
          child: Icon(
            IconData(exercise.icon.codePoint,
                fontFamily: exercise.icon.fontFamily),
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildNameLabel(String name) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 80,
      child: AutoSizeText(
        name,
        maxLines: 1,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 25),
      ),
    );
  }

  Widget _buildCardHeader(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: _buildIconCircle(exercise)),
          SizedBox(width: 20),
          Expanded(flex: 2, child: _buildNameLabel(exercise.name)),
        ],
      ),
    );
  }

  List<Widget> _buildInfoSection({String text, String noDataText}) {
    return (text != null && text.isNotEmpty)
        ? [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AutoSizeText(
                (text != null && text.isNotEmpty) ? text : noDataText,
                minFontSize: 16,
                maxFontSize: 16,
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: (text != null && text.isNotEmpty)
                        ? Colors.black
                        : null),
                textAlign: TextAlign.left,
              ),
            ),
            ...sectionDivider,
          ]
        : [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
            )
          ];
  }

  /*Widget _builTargetIcon(BODYPARTS target) {
    return BodyPartIcon(part: target, iconSize: 30,);
  }*/

  Widget _buildTargetsGrid(List<BODYPARTS> targets) {
    return (targets != null && targets.isNotEmpty)
        ? BodyPartsIconsGrid(parts: targets, iconSize: 30, maxCrossAxisExtent: 90,)
        : Padding(
            padding: EdgeInsets.all(0),
          );
  }

  Widget _buildExerciseCardContent(Exercise exercise) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(exercise),
          ...sectionDivider,
          ..._buildInfoSection(text: exercise.equipment, noDataText: ''),
          ..._buildInfoSection(text: exercise.about, noDataText: ''),
          _buildTargetsGrid(exercise.bodyParts)
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    if (exercise.name != null && exercise.name.isNotEmpty)
      return InkWell(
        onTap: () => _editExercise(exercise.id),
        child: Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: _buildExerciseCardContent(exercise)),
      );
    else {
      exercises.removeExerciseWithoutNotifying(exercise.id, context);
      return null;
    }
  }

  Widget _buildExerciseCardEntry(Exercise exercise) {
    return Dismissible(
      key: UniqueKey(),
      dismissThresholds: {DismissDirection.endToStart: 0.75},
      background: DismissibleBackground(context).delete,
      direction: DismissDirection.endToStart,
      onDismissed: (dir) => _removeExercise(exercise.id),
      confirmDismiss: Dialogs(context).confirmRemoveDialog,
      child: _buildExerciseCard(exercise),
    );
  }

  List<Widget> get sectionDivider {
    return [
      Divider(),
      SizedBox(height: 10),
    ];
  }

  List<Widget> get appBarActions {
    return [
      IconButton(
        onPressed: _addNewExercise,
        icon: Icon(Icons.add),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    exercises = Provider.of<ExercisesProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('My Exercises'),
        actions: <Widget>[
          ...appBarActions,
        ],
      ),
      body: (exercises.exercisesList.length > 0)
          ? ListView.separated(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              shrinkWrap: true,
              itemBuilder: (ctx, i) =>
                  _buildExerciseCardEntry(exercises.exercisesList[i]),
              itemCount: exercises.exercisesList.length,
              separatorBuilder: (ctx, i) => SizedBox(height: 15),
            )
          : Center(
              child: Text(
                'You have not added any exercises yet',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
    );
  }
}
