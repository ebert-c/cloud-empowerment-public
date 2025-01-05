import 'dart:convert';
import 'dart:core';
import 'package:cloudempowerment/model/patient_model.dart';
import 'package:cloudempowerment/model/session_model.dart';
import 'package:cloudempowerment/model/user_model.dart';
import 'package:cloudempowerment/util/const.dart';
import 'package:cloudempowerment/util/util.dart';

import '../util/api.dart';

class Encounter {
  Encounter({
    required this.provider,
    required this.patient,
    Map<String, Map<String, dynamic>>? encounterData
}) : this.encounterData = encounterData ?? {};
  User provider;
  Patient patient;
  Map<String, Map<String, dynamic>> encounterData;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  static const testResultList = ["Test", "Result"];


  void addComponentData(String componentName, Map<String, dynamic> componentData) {
    encounterData[componentName] = componentData;
  }

  Future<bool> saveEncounter(Session session) async {
    bool remoteAdded = false;
    String encounterDataString = jsonEncode(this.encounterData);
    await session.databaseHelper.saveEncounter('${session.currentUser.getFullNameInverted()}', this.patient, this.id, encounterDataString);
    if(await AppConnectivity.isConnected()) {
      Map<String, String> visit = await session.databaseHelper.getVisit(this.id);
      Map<String, dynamic> encounterData = jsonDecode(visit['encounterData']!);
      remoteAdded = await ApiManager().addEncounter(session, encounterData, this.patient.patient_identity, encounterData[COMPONENT_NAMES.MEDICAL_VISIT]);
    }
    if (!remoteAdded) {
      await session.databaseHelper.addUpdate(this.id, UPDATE_TYPE.ENCOUNTER, UPDATE_ACTION.CREATE);
      return false;
    }
    return true;
  }

  static Future<bool> insertEncounterFromRemote(Session session, Map<String, dynamic> encounterData, Patient p, String id) async {
    String encounterDataString = encodeRemoteEncounter(encounterData, session);
    await session.databaseHelper.saveEncounter('${session.currentUser.getFullNameInverted()}', p, id, encounterDataString);
    return true;
  }

  static String encodeRemoteEncounter(Map<String, dynamic> visitData, Session session) {
    var encounterData = visitData;
    Map<String, dynamic> localEncounter = {
        "medical-visit": {
          "provider": session.currentUser.getTitle(),
          "dateTime": encounterData["created_at"],
          "gps": "Latitude: ${encounterData["latitude"]} Longitude: ${encounterData["longitude"]}",
          "visitType": encounterData["visit_type"],
          "reasonForVisit": convertRemoteMap(encounterData['reson'],
              ["reson_number", "reson_name"], ["code", "display"])},
        "vitals": {
          // "bloodPressureSystolic": encounterData["vaital_blood"].substring(0, encounterData["vaital_blood"].indexOf("/")),
          // "bloodPressureDiastolic": encounterData["vaital_blood"].substring(encounterData["vaital_blood"].indexOf("/") + 1),
          "bloodPressureSystolic": encounterData["vaital_blood_pressure"],
          "bloodPressureDiastolic": encounterData["vaital_blood_pressure"],
          "weight": encounterData["vaital_weight"],
          "height": encounterData["vaital_height"],
          "temperature": encounterData["vaital_temperature"],
          "oxygenSaturation": encounterData["vaital_oxygen_saturation"],
          "notes": encounterData["vaital_notes"],
        },
        "examination": {
          "history": encounterData["examination_history"],
          "physicalExamination": encounterData["physical_examination"],
          "assessment": encounterData["examination_assessment"],
          "diagnosis": encounterData["examination_diagnosis"],
          "plan": encounterData["examination_plan"],
          "files": [],
          "notes": encounterData["examination_text"]
        },
        "imaging": {
          "procedures": getTestResultList(encounterData["imaging_test"],
              encounterData["imaging_test_result"], testResultList),
          "files": [],
          "notes": encounterData["imaging_notes"],
        },
        "laboratory": {
          "procedures": getTestResultList(encounterData["laboratory_test"],
              encounterData["laboratory_test_result"], testResultList),
          "files": [],
          "notes":encounterData["laboratory_notes"]
        },
        "pathology": {
          "procedures": getTestResultList(encounterData["pathology_test"],
              encounterData["pathology_test_result"], testResultList),
          "files": [],
          "notes":encounterData["pathology_notes"]
        },
        "radiology": {
          "procedures": getTestResultList(encounterData["radiology_test"],
              encounterData["radiology_test_result"], testResultList),
          "files": [],
          "notes": encounterData["radiology_notes"]
        },
        "surgery": {
          "procedures": getTestResultList(encounterData["surgery_test"],
              encounterData["surgery_test_result"], testResultList),
          "files": [],
          "notes": encounterData["surgery_notes"]
        },
        "vaccination": {
          "vaccines": getTestResultList(encounterData["vaccine"],
          encounterData["dosage"], ["Vaccine", "Dosage"]),
          "files": [],
          "notes": encounterData["vaccine_notes"]
        },
        "program-admission": {
          "programs": getTestResultList(encounterData["program_names"],
              encounterData["programs_duration"], ["Program Name", "Duration"]),
          "files": [],
          "notes": encounterData["program_notes"]
        },
        "prescription": {
          "prescriptions": getPrescriptionList(encounterData["drug"],
              encounterData["prescriptions_dosage"]),
          "files": [],
          "notes": encounterData["program_notes"]
      },
    };

    return jsonEncode(localEncounter);
  }

  static List<Map<String, dynamic>> getTestResultList(dynamic test,
      dynamic result, List<String> keys) {
    if (test == null || result == null) {
      return [];
    }
    if (test.runtimeType == String) {
      test = jsonDecode(test);
    }
    if (result.runtimeType == String) {
      result = jsonDecode(result);
    }
    List<Map<String, dynamic>> resultList = [];
    for(int i = 0; i < test.length; i++) {
      resultList.add({keys[0]: test[i], keys[1]: result[i]});
    }
    return resultList;
  }

  static List<Map<String, dynamic>> getPrescriptionList(List<dynamic>? prescription,
      List<dynamic>? dosage) {
    if (prescription == null || dosage == null) {
      return [];
    }
    List<Map<String, dynamic>> resultList = [];
    for(int i = 0; i < prescription.length; i++) {
      resultList.add({"display": prescription[i]["brand_name"],
        "code": prescription[i]["drug_code"], "dosage": dosage[i]});
    }
    return resultList;
  }

  static List<Map<String, dynamic>> convertRemoteMap(List<dynamic> remote,
      List<String> remoteKeys, List<String> localKeys) {
    List<Map<String, dynamic>> result = [];
    for(var r in remote) {
      result.add({localKeys[0]: r[remoteKeys[0]], localKeys[1]: r[remoteKeys[1]]});
    }



    return result;
  }

}
