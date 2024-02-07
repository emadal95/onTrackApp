import 'package:flutter/material.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/screens/account_screen.dart';
import 'package:gym_tracker/screens/custom_exercises_screen.dart';
import 'package:gym_tracker/screens/custom_workouts_screen.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/screens/tab_screen.dart';
import 'package:provider/provider.dart';
import 'providers/sets_provider.dart';
import 'screens/workout_creation_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => UserProvider()),
        ChangeNotifierProvider(builder: (context) => WorkoutsProvider()),
        ChangeNotifierProvider(
          builder: (context) => ExercisesProvider(),
        ),
        ChangeNotifierProvider(
          builder: (context) => SetsProvider(),
        ),
        ChangeNotifierProvider(
          builder: (context) => ExerciseSessionsProvider(),
        ),
        ChangeNotifierProvider(
          builder: (context) => WorkoutSessionsProvider(),
        )
      ],
      child: ChangeNotifierProvider.value(
        value: UserProvider(),
        child: MaterialApp(
          title: 'Workout Tracker',
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.amber,
            backgroundColor: Color.fromRGBO(237, 236, 236, 1),
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(
                      button: TextStyle(fontSize: 12),
                      title: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
            textTheme: ThemeData.light().textTheme.copyWith(
                display1: TextStyle(
                    fontFamily: 'Kaushan Script', color: Colors.black)),
          ),
          routes: {
            '/': (ctx) => TabScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            CustomWorkoutsScreen.routeName: (ctx) => CustomWorkoutsScreen(),
            CustomExercisesScreen.routeName: (ctx) => CustomExercisesScreen(),
            AccountScreen.routeName: (ctx) => AccountScreen(),
            WorkoutCreationScreen.routeName: (ctx) => WorkoutCreationScreen(),
          },
        ),
      ),
    );
  }
}
