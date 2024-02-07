
import 'package:flutter/foundation.dart';

class SessionsProvider extends ChangeNotifier {
  var sessions = [];

  setSessionsList({newSessionsList}){
    sessions = newSessionsList;
    notifyListeners();
  }

  removeSession({String sessionId}){
    sessions.removeWhere((session) => session.id == sessionId);
    notifyListeners();
  }

  insertSession({newSession}){
    sessions.add(newSession);
    notifyListeners();
  }

  getSessionById({String sessionId}){
    return sessions.firstWhere((session) => session.id == sessionId);
  }

  List get sessionsList {
    return [...sessions];
  }

}