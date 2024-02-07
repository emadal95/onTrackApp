import 'package:animator/animator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/icons/tools_icons.dart';
import '../icons/tools_icons.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/widgets/customs/dialogs.dart';
import 'package:gym_tracker/widgets/customs/dismissible_background.dart';
import 'package:gym_tracker/widgets/workout_sessions/workout_session_card.dart';
import 'package:provider/provider.dart';

class SessionsScreen extends StatefulWidget {
  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final double pageHeaderHeightFactor = (1 / 3.5);
  final IconData ascendingIcon = ToolsIcons.chevron_down_circle;
  final IconData descendingIcon = ToolsIcons.chevron_up_circle;
  Map<String, DateTime> datesFilters = {'from': null, 'to': null};
  String searchQuery = "";
  bool inAscendingOrder = false;
  bool showSearchField = false;
  bool filteringByDate = false;

  void _onRemoveSession(String workoutSessionId) {
    Provider.of<WorkoutSessionsProvider>(context).removeWorkoutSessions(
        context: context, workoutSessionIds: [workoutSessionId]);
  }

  void _onAddCustomWorkoutSession() {
    //TODO
  }

  void _onSort() {
    setState(() {
      inAscendingOrder = !inAscendingOrder;
    });
  }

  void _onSearch(searchQ) {
    setState(() {
      searchQuery = searchQ;
      showSearchField = false;
    });
  }

  Future _pickDateRange() {
    return DateRangePicker.showDatePicker(
      context: context,
      initialFirstDate: DateTime.now().subtract(Duration(days: 7)),
      initialLastDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DateRangePicker.DatePickerMode.day,
    );
  }

  void _setFilteringDates(DateTime from, DateTime until) {
    setState(() {
      filteringByDate = true;
      datesFilters['from'] = from;
      datesFilters['to'] = until;
    });
  }

  void _clearDatesFilter() {
    setState(() {
      filteringByDate = false;
      datesFilters['from'] = null;
      datesFilters['to'] = null;
    });
  }

  void _onClearSearch() {
    if (searchQuery != '')
      setState(() {
        searchQuery = '';
      });
  }

  void _onFilterByDate() async {
    if (filteringByDate) {
      _clearDatesFilter();
      return;
    }

    List<DateTime> picked = await _pickDateRange();
    if (picked != null && picked.length >= 1)
      _setFilteringDates(picked[0], (picked.length > 1) ? picked[1] : null);
  }

  void _onRequestSearchField() {
    setState(() {
      showSearchField = !showSearchField;
    });
  }

  List _retrieveSessionsAccordingToFilters() {
    WorkoutSessionsProvider sessionsProvider =
        Provider.of<WorkoutSessionsProvider>(context);
    var sessions = [];
    if (searchQuery != '' && !filteringByDate)
      sessions = sessionsProvider.filterSessionsByWorkoutName(searchQuery);
    else if (searchQuery != '' && filteringByDate)
      sessions = sessionsProvider.filterSessionsByDateAndWorkoutName(
          datesFilters, searchQuery);
    else if (filteringByDate && datesFilters['to'] != null)
      sessions = sessionsProvider.filterSessionsByDateRange(
          from: datesFilters['from'], until: datesFilters['to']);
    else if (filteringByDate && datesFilters['to'] == null)
      sessions = sessionsProvider.filterSessionsByDate(datesFilters['from']);
    else
      sessions = Provider.of<WorkoutSessionsProvider>(context).sessionsList;

    (inAscendingOrder)
        ? sessions.sort((a, b) => a.date.compareTo(b.date))
        : sessions.sort((a, b) => b.date.compareTo(a.date));

    return sessions;
  }

  Widget _buildpageHeader(bool hasSessions) {
    return Container(
      height: MediaQuery.of(context).size.width * pageHeaderHeightFactor,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: Theme.of(context).primaryColor, width: 1)),
      ),
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.end,
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(flex: 1, child: _buildPageTitle()),
          SizedBox(width: 20),
          Flexible(
              flex: 1,
              child: (showSearchField) ? _buildSearchBar() : _buildPageTools())
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FittedBox(
        fit: BoxFit.contain,
        child: AutoSizeText(
          'Sessions',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 100),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Animator(
      tween:
          Tween<double>(begin: 44, end: MediaQuery.of(context).size.width / 2),
      repeats: 1,
      duration: Duration(milliseconds: 500),
      builder: (animation) => Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 40,
          width: animation.value,
          alignment: Alignment.bottomCenter,
          child: TextFormField(
            onFieldSubmitted: (searchQuery) => _onSearch(searchQuery),
            cursorColor: Theme.of(context).primaryColor,
            cursorWidth: 1,
            initialValue: searchQuery,
            textInputAction: TextInputAction.done,
            autofocus: true,
            maxLines: 1,
            decoration: InputDecoration(
                suffixIcon: Icon(ToolsIcons.search, size: 22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: EdgeInsets.all(10),
                labelText: 'search by name',
                labelStyle: TextStyle(fontSize: 12)),
          )),
    );
  }

  Widget _buildFilterIcon(IconData icon, double size, Function onPress,
      Function onLongPress, bool highlighted) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: IconButton(
        onPressed: onPress,
        icon: Icon(
          icon,
          size: size,
          color: (highlighted)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildToolsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildFilterIcon(ToolsIcons.search, 25, _onRequestSearchField,
            _onClearSearch, searchQuery != ''),
        _buildFilterIcon(ToolsIcons.calendar_empty, 20, _onFilterByDate,
            _onFilterByDate, filteringByDate),
        IconButton(
          onPressed: _onSort,
          icon: Icon((inAscendingOrder) ? ascendingIcon : descendingIcon,
              size: 20),
        ),
        IconButton(onPressed: _onAddCustomWorkoutSession, icon: Icon(Icons.add))
      ],
    );
  }

  Widget _buildPageTools() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: FittedBox(fit: BoxFit.contain, child: _buildToolsRow()),
    );
  }

  Widget _buildScrollView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 8,
        right: 10,
        left: 10,
        bottom: 40,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Column(
          children: workoutSessionCards,
        ),
      ),
    );
  }

  Widget _buildSessionCard(WorkoutSession session) {
    return Dismissible(
      key: UniqueKey(),
      dismissThresholds: {DismissDirection.endToStart: 0.75},
      background: DismissibleBackground(context).delete,
      onDismissed: (direction) => _onRemoveSession(session.id),
      confirmDismiss: Dialogs(context).confirmRemoveDialog,
      direction: DismissDirection.endToStart,
      child: WorkoutSessionCard(workoutSession: session),
    );
  }

  Widget _buildNoDataWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: AutoSizeText(
            'No workout sessions available.',
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: AutoSizeText(
            'Navigate to the right tab to select a workout and start a new session.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }

  List<Widget> get workoutSessionCards {
    List<Widget> sessionCards = [];
    List sessions = _retrieveSessionsAccordingToFilters();
    sessions.forEach((session) => sessionCards.add(_buildSessionCard(session)));
    return sessionCards;
  }

  @override
  Widget build(BuildContext context) {
    bool hasSessions = workoutSessionCards.length > 0;
    return Column(
      children: [
        _buildpageHeader(hasSessions),
        Expanded(
            child: (hasSessions) ? _buildScrollView() : _buildNoDataWidget()),
      ],
    );
  }
}
