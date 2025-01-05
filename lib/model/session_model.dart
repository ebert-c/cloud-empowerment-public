import 'package:cloudempowerment/util/local_database.dart';
import 'package:cloudempowerment/model/user_model.dart';
import 'encounter_model.dart';

class Session {
  late User currentUser;
  Map<String, dynamic> viewArguments = {};
  Encounter? encounter = null;
  String token = "";

  bool isValid = false;
  DatabaseHelper databaseHelper;


  Session({required this.databaseHelper});

  void clearArguments() {
    viewArguments.clear();
  }

  Map<String, dynamic> popArguments() {
    Map<String, dynamic> tempArgs = this.viewArguments;
    clearArguments();
    return tempArgs;
  }

  dynamic getArg(String key) {
    return viewArguments[key];
  }

  void setArgs(Map<String, dynamic> args) {
    this.viewArguments = args;
  }

  void addArg(String key, dynamic value) {
    this.viewArguments[key] = value;
  }

  Future<void> invalidate() async {
    this.encounter = null;
    this.currentUser.invalidate();
    this.clearArguments();
    await this.databaseHelper.closeUserDatabase();
  }


}