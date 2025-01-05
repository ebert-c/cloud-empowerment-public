import 'dart:core';
import 'package:cloudempowerment/model/user_model.dart';
import 'package:cloudempowerment/util/api.dart';
import 'package:cloudempowerment/util/util.dart';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import 'const.dart';
import 'local_database.dart';

class LoginController {
  LoginController();

  Future<Session> login(
      String email, String password, Session? newSession) async {
    User? user;
    Session session =
        newSession ?? new Session(databaseHelper: new DatabaseHelper());
    await session.databaseHelper.initializeDatabaseHelper();
    user = await session.databaseHelper.getUser(email, password);
    if (user == null) {
      if (await AppConnectivity.isConnected()) {
        user = await remoteLogin(email, password, session);
        if (user != null) {
          session.isValid = true;
          session.currentUser = user;
          bool success = await ApiManager().updateLocalPatients(session);
          if (!success) {
            showToast(STRINGS.ERROR_RETRIEVING_PATIENT_DATA);
          }
          return session;
        }
      }
    }
    if (user == null) {
      session.isValid = false;
      return session;
    } else {
      if (await AppConnectivity.isConnected() && session.token == ""){
        String? token = await ApiManager().getToken(email, password);
        session.token = token ?? "";
      }
      session.isValid = true;
      session.currentUser = user;
      return session;
    }
  }

  Future<User?> remoteLogin(String email, String password, Session session) async {

    Map<String, dynamic>? authData = await ApiManager().login(email, password);
    if (authData == null) {
      return null;
    }
    Map<String, dynamic> userData = authData['data']['user'];

    User user = User.fromRemoteJson(userData);

    session.token = authData['data']['token']['original']['access_token'];

    await session.databaseHelper.insertNewUser(email, user, password);
    return user;
  }

  static Future<void> logout(BuildContext context, Session session) async {
    await session.invalidate();
    Navigator.pushNamedAndRemoveUntil(
      context,
      ROUTES.LOGIN,
      (route) => false,
    );
  }
}
