import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/timer/timer_controller.dart';

class TimerCard extends StatefulWidget {
  String title;
  Color color;
  Function onStartTimer;
  Function onResetTimer;
  Function onPauseTimer;
  Dependencies watchDependencies;

  TimerCard({this.title, this.color, this.onResetTimer, this.onStartTimer, this.onPauseTimer, this.watchDependencies});
  

  _TimerCardState createState() => _TimerCardState();

}

class _TimerCardState extends State<TimerCard> {
  bool isRunning = false;
  bool isZero = true;

  void _onStartTimer() {
    widget.onStartTimer();
    setState(() {
      isRunning = true;
    });
  }

  void _onResetTimer() {
    widget.onResetTimer();
    setState(() {
      isRunning = false;
    });
  }

  void _onPauseTimer() {
    widget.onPauseTimer();
    setState(() {
      isRunning = false;
    });
  }

  Widget _buildTimerTitle() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 20,
      child: AutoSizeText(
        widget.title,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildButtonIcon(
      {String title, IconData icon, Color btnColor, Function onPressFn}) {
    return IconButton(
        icon: Icon(icon),
        color: btnColor,
        disabledColor: Colors.grey,
        iconSize: 70,
        onPressed: onPressFn);
  }

  Widget _buildWatch() {
    return Container(
        width: double.infinity,
        height: 85,
        child: TimerText(dependencies: widget.watchDependencies));
  }

  Widget _buildWatchTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildButtonIcon(
          title: '',
          btnColor: Colors.white,
          icon: Icons.refresh,
          onPressFn: _onResetTimer
        ),
        _buildButtonIcon(
          title: '',
          btnColor: Colors.amberAccent,
          icon: Icons.pause_circle_filled,
          onPressFn:
              (isRunning) ? _onPauseTimer : null,
        ),
        _buildButtonIcon(
          title: '',
          btnColor: Colors.greenAccent,
          icon: Icons.play_circle_filled,
          onPressFn:
              (isRunning) ? null : _onStartTimer,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildTimerTitle(),
            _buildWatch(),
            _buildWatchTools(),
          ],
        ),
      ),
    );
  }
}
