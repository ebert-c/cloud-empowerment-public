import 'package:cloudempowerment/model/patient_model.dart';
import 'package:cloudempowerment/model/user_model.dart';
import 'package:cloudempowerment/util/const.dart';
import 'package:cloudempowerment/util/util.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

import 'package:sqflite_common/src/exception.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import '../model/form_model.dart';

class DatabaseHelper {
  late Database _userDatabase;
  late Database _loginDatabase;
  Lock _lock = new Lock();

  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<bool> initializeDatabaseHelper() async {
    return await _openLoginDatabase();
  }

  Future<bool> _openUserDatabase(String email, String password) async {
    try {
      String? path = await getUserDatabasePath(email);
      if (path == null) {
        return false;
      }
      await _lock.synchronized(() async {
        try {
          _userDatabase = await openDatabase(path,
              onCreate: _onCreateUserDatabase, password: password, version: 1);
        } catch (DatabaseException, e) {
          print(e);
          return false;
        }
      });
      return true;
    } catch (e) {
      SqfliteDatabaseException eTrue = e as SqfliteDatabaseException;
      print(eTrue.message);
      print(eTrue.toString());
      debugPrint('here');
      return false;
    }
  }

  Future<bool> _openLoginDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "users.db");
    await _lock.synchronized(() async {
      try {
        _loginDatabase = await openDatabase(path,
            onCreate: _onCreateLoginDatabase, version: 1);
      } catch (DatabaseException, e) {
        print(e);
        return false;
        //TODO log error
      }
    });
    return true;
  }

  Future<String?> getUserDatabasePath(String email) async {
    String emailHash = Crypt.sha256(email, salt: "").hash;
    var databaseIdList = await _loginDatabase.query('users',
        where: 'userId = ?', whereArgs: [emailHash], columns: ['databaseId']);
    if (databaseIdList.isEmpty) {
      return null;
    }

    String databaseId = databaseIdList.first['databaseId'] as String;
    return join(await getDatabasesPath(), databaseId + ".db");
  }

  Future<void> insertNewUser(String email, User user, String password) async {
    String emailHash = Crypt.sha256(email, salt: "").hash;
    Map<String, String> values = {};
    values["userId"] = emailHash;
    values["databaseId"] = user.identity_id;
    try {
      await _loginDatabase.insert('users', values,
          conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      // user already exists
      print("User already exists");
    }

    await _openUserDatabase(email, password);
    await insertObjectToUserDatabase(user, DATABASE_TABLE_NAMES.USER_TABLE);
  }

  Future<void> insertObjectToUserDatabase(
      var object, String databaseTable) async {
    Map<String, dynamic> json = object.toLocalJson();
    await insertJsonToUserDatabase(json, databaseTable);
  }

  Future<void> insertJsonToUserDatabase(
      Map<String, dynamic> json, String databaseTable) async {
    await _userDatabase.insert(databaseTable, json,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUser(User user) async {
    await insertObjectToUserDatabase(user, DATABASE_TABLE_NAMES.USER_TABLE);
  }

  Future<User?> getUser(String email, String password) async {
    try {
      bool correctPassword = await _openUserDatabase(email, password);
      if (!correctPassword) {
        return null;
      }
      final userList = await _userDatabase.query(
          DATABASE_TABLE_NAMES.USER_TABLE,
          where: 'email = ?',
          whereArgs: [email]);
      final userJson = userList.first;
      return User.fromLocalJson(userJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> closeUserDatabase() async {
    await _userDatabase.close();
  }

  Future<void> closeLoginDatabase() async {
    await _loginDatabase.close();
  }

  Future<Patient?> getPatient(String id) async {
    final patientList = await _userDatabase.query(
        DATABASE_TABLE_NAMES.PATIENTS_TABLE,
        where: 'patient_identity = ?',
        whereArgs: [id]
    );
    if (patientList.isEmpty) {
      return null;
    }
    final patientJson = patientList.first;
    return Patient.fromLocalJson(patientJson);
  }

  Future<void> insertForm(LocalForm form) async {
    Map<String, dynamic> json = form.toJson();
    await _userDatabase.insert(DATABASE_TABLE_NAMES.FORMS_TABLE, json,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<LocalForm>> getForms() async {
    final formList =
        await _userDatabase.query(DATABASE_TABLE_NAMES.FORMS_TABLE);
    if (formList.isEmpty) {
      return [];
    }
    List<LocalForm> forms = [];
    for (var f in formList) {
      forms.add(LocalForm.fromJson(f));
    }
    return forms;
  }

  Future<List<Representation>> getPatientNamesAndPhotos() async {
    List<Representation> patients = [];
    var patientList =
        await _userDatabase.query(DATABASE_TABLE_NAMES.PATIENTS_TABLE);
    for (var p in patientList) {
      patients.add(new Representation(
        label: '${p['lastName']}, ${p['firstName']}',
        id: p['patient_identity'] as String,
        icon: p['photo'] as String,
      ));
    }

    return patients;
  }

  Future<List<Map<String, String>>> getHistory(String patientId) async {
    List<Map<String, String>> encounters = [];
    var encounterList = await _userDatabase.query(
        DATABASE_TABLE_NAMES.HISTORY_TABLE,
        where: 'patientId = ?', whereArgs: [patientId]
    );
    for (var p in encounterList) {
      encounters.add(
        {'encounterId': p['encounterId'] as String,
          'providerName': p['providerName'] as String,
          'date': DateTime.fromMillisecondsSinceEpoch(int.parse(p['encounterId'] as String)).toString().substring(0, 16)
        }
      );
    }
    return encounters;
  }

  Future<Map<String, String>> getVisit(String encounterId) async {
    Map<String, String> visit = {};
    var visitData = await _userDatabase.query(
        DATABASE_TABLE_NAMES.HISTORY_TABLE,
        where: 'encounterId = ?', whereArgs: [encounterId]
    );

    if(visitData.isEmpty) {
      return visit;
    }

    var selectedVisit = visitData.first;

    visit['encounterId'] = selectedVisit['encounterId'] as String;
    visit['patientId'] = selectedVisit['patientId'] as String;
    visit['providerName'] = selectedVisit['providerName'] as String;
    visit['encounterData'] = selectedVisit['encounterData'] as String;

    return visit;
  }

  Future<void> updatePatientToRemoteId(String id, String oldId) async {
    await _userDatabase.update(
        DATABASE_TABLE_NAMES.PATIENTS_TABLE,
        {'patient_identity': id},
        where: 'patient_identity = ?',
        whereArgs: [oldId]);
  }

  Future<Map<String, String>> getPatientNames(User user) async {
    Map<String, String> nameMap = {};
    var patientList =
        await _userDatabase.query(DATABASE_TABLE_NAMES.PATIENTS_TABLE);
    for (var p in patientList) {
      nameMap[p["id"] as String] =
          "${p["firstName"] as String} ${p["lastName"]}";
    }

    return nameMap;
  }

  Future<int> getPatientNumber(User user) async {
    return (await getPatientNames(user)).length;
  }

  Future<void> saveEncounter(String providerName, Patient patient,
      String encounterId, String encounterData) async {
    Map<String, dynamic> encData = {
      'encounterId': encounterId,
      'patientId': patient.patient_identity,
      'providerName': providerName,
      'encounterData': encounterData,
    };
    await _userDatabase.insert(DATABASE_TABLE_NAMES.HISTORY_TABLE, encData);
  }

  Future<List<Patient>> getAllPatients(User user) async {
    List<Patient> allPatients = [];
    var patientList =
        await _userDatabase.query(DATABASE_TABLE_NAMES.PATIENTS_TABLE);
    for (var p in patientList) {
      allPatients.add(Patient.fromLocalJson(p));
    }
    return allPatients;
  }

  Future<void> addUpdate(String id, String type, String action) async {
    Map<String, dynamic> updateJson = {
      'id': id,
      'type': type,
      'action': action
    };
    await _userDatabase.insert(DATABASE_TABLE_NAMES.UPDATES_TABLE, updateJson);
  }

  Future<List<Map<String, dynamic>>> getUpdates() async {
    List<Map<String, dynamic>> updates = [];
    var updateList = await _userDatabase.query(DATABASE_TABLE_NAMES.UPDATES_TABLE);
    for (var u in updateList) {
      updates.add({
        'id': u['id'],
        'type': u['type'],
        'action': u['action']
      });
    }
    return updates;
  }

  Future<void> deleteUpdate(String id) async {
    await _userDatabase.delete(DATABASE_TABLE_NAMES.UPDATES_TABLE,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _onCreateUserDatabase(Database db, int version) async {
    await db.execute(DATABASE_SCHEMAS.CREATE_USER_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_PATIENTS_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_MESSAGES_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_CREDENTIALS_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_FORMS_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_HISTORY_TABLE);
    await db.execute(DATABASE_SCHEMAS.CREATE_UPDATES_TABLE);
  }

  Future<void> _onCreateLoginDatabase(Database db, int version) async {
    await db.execute(DATABASE_SCHEMAS.CREATE_LOGIN_TABLE);
  }
}
