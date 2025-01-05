import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloudempowerment/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../model/patient_model.dart';
import '../model/session_model.dart';
import 'const.dart';
import "../model/encounter_model.dart";

class ApiManager {
  final hostname = 'https://zimcan-health.com/api';
  final hostname2 =
      'http://127.0.0.1:8000/assets/img/patient-files'; // any patient files
  final hostname3 =
      "http://127.0.0.1:8000/assets/img/users/"; // any user photos

  Future<Map<String, dynamic>?> login(String email, String password) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(hostname + '/doctor/login'));
    request.fields.addAll({'email': email, 'password': password});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();

      var json = jsonDecode(data);
      return json;
    } else {
      return null;
    }
  }

  dynamic listReviver(dynamic key, dynamic value) {
    if (value is String) {
      try {
        return jsonDecode(value);
      } catch (e) {
        return value;
      }

    }
    return value;
  }

  Future<bool> updateLocalPatients(Session session) async {
    var headers = {'Authorization': 'Bearer ${session.token}'};
    var request = http.Request(
        'GET', Uri.parse(hostname + '/patient/patients/by/doctor'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      for (var remoteJson in json['data']) {
        var filesReq = http.Request('GET', Uri.parse(hostname +
            '/patient/patient/file/${remoteJson['patient_identity']}'));
        filesReq.headers.addAll(headers);
        http.StreamedResponse files = await filesReq.send();
        print(await files.stream.bytesToString());
        print(remoteJson['photo']);
        remoteJson['photo'] = ""; //TODO Replace with file get
        Patient patient = Patient.fromRemoteJson(remoteJson);
        await session.currentUser.insertPatientFromRemote(patient, session);

        var encounterRequest = http.Request('GET', Uri.parse(hostname + '/patient/show-patient/${remoteJson['patient_identity']}'));
        encounterRequest.headers.addAll(headers);
        http.StreamedResponse encounterResponse = await encounterRequest.send();
        var patientData = jsonDecode(await encounterResponse.stream.bytesToString());
        for (var encounterData in patientData['data']['medical_visits']) {
          var recoded = jsonEncode(encounterData);
          var filtered = jsonDecode(recoded, reviver: listReviver);
          Encounter.insertEncounterFromRemote(session, filtered, patient, encounterData['id'].toString());
        }

      }
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken(String email, String password) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(hostname + '/doctor/login'));
    request.fields.addAll({'email': email, 'password': password});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();

      var json = jsonDecode(data);
      return json['data']['token']['original']['access_token'];
    } else {
      return null;
    }
  }

  Future<void> getDocuments(Session session) async {
    var headers = {'Authorization': 'Bearer ${session.token}'};

    var request =
        http.MultipartRequest('GET', Uri.parse(hostname + '/dcoument/ligrary'));
    request.headers.addAll(headers);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> registerPatient(Session session, Patient patient) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(hostname + '/patient/registration'));
    var headers = {'Authorization': 'Bearer ${session.token}'};
    request.headers.addAll(headers);
    Map<String, String> patientJson = patient.toRemoteJson();
    request.fields.addAll(patientJson);
    if (patient.photo != null) {
      List<int> bytes = await base64Decode(patient.photo!);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/patientPhoto');
      await file.writeAsBytes(bytes);
      request.files.add(await http.MultipartFile.fromPath('photo', file.path));
    }
    try {
      http.StreamedResponse response = await request.send();
      String data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("RegisterPatient");
        print(data);
        return jsonDecode(data)['patient_id'];
      }
    } on Exception catch (_){
      showToast("Connection error while sending patient");
    }
    print("Patient insert failed");
    return "";
  }

  List<dynamic> getListsFromMap(List<dynamic>? maps) {
    List<String> testList = [];
    List<String> resultList = [];
    if (maps == null) {
      return [jsonEncode(testList), jsonEncode(resultList)];
    }
    for (var entry in maps) {
      testList.add(entry['Test']);
      resultList.add(entry['Result']);
    }
    return [jsonEncode(testList), jsonEncode(resultList)];
  }

  List<dynamic> getSpecialListsFromMap(
      List<dynamic>? maps, String list1name, String list2name) {
    List<dynamic> list1 = [];
    List<dynamic> list2 = [];
    if (maps == null) {
      return [jsonEncode(list1), jsonEncode(list2)];
    }
    for (var entry in maps) {
      list1.add(entry[list1name]);
      list2.add(entry[list2name]);
    }
    return [jsonEncode(list1), jsonEncode(list2)];
  }

  List<dynamic> getPrescriptionListsFromMap(List<dynamic>? prescriptions) {
    List<dynamic> names = [];
    List<dynamic> codes = [];
    List<dynamic> dosages = [];

    if (prescriptions == null) {
      return ['[]','[]','[]'];
    }
    for (var entry in prescriptions) {
      names.add(entry['display']);
      codes.add(entry['code']);
      dosages.add(entry['dosage']);
    }

    return [jsonEncode(names), jsonEncode(codes), jsonEncode(dosages)];
  }

  Future<bool> addEncounter(Session session, Map<String, dynamic> encounterData,
      String patientId, var medicalVisit) async {
    Map<String, dynamic> examination =
        encounterData[COMPONENT_NAMES.EXAMINATION] ?? {};
    Map<String, dynamic> imaging = encounterData[COMPONENT_NAMES.IMAGING] ?? {};
    Map<String, dynamic> laboratory =
        encounterData[COMPONENT_NAMES.LABORATORY] ?? {};
    Map<String, dynamic> pathology =
        encounterData[COMPONENT_NAMES.PATHOLOGY] ?? {};
    Map<String, dynamic> prescription =
        encounterData[COMPONENT_NAMES.PRESCRIPTION] ?? {};
    Map<String, dynamic> programAdmission =
        encounterData[COMPONENT_NAMES.PROGRAM_ADMISSION] ?? {};
    Map<String, dynamic> radiology =
        encounterData[COMPONENT_NAMES.RADIOLOGY] ?? {};
    Map<String, dynamic> surgery = encounterData[COMPONENT_NAMES.SURGERY] ?? {};
    Map<String, dynamic> vaccination =
        encounterData[COMPONENT_NAMES.VACCINATION] ?? {};
    Map<String, dynamic> vitals = encounterData[COMPONENT_NAMES.VITALS] ?? {};

    var latitude = medicalVisit['gps']?.split(" ")[1];
    var longitude = medicalVisit['gps']?.split(" ")[3];


    var examinationList = getSpecialListsFromMap(examination['diagnosis'], 'code', 'display')[0];

    var laboratoryList = getListsFromMap(laboratory['procedures']);
    var imagingList = getListsFromMap(imaging['procedures']);
    var pathologyList = getListsFromMap(pathology['procedures']);
    var radiologyList = getListsFromMap(radiology['procedures']);
    var surgeryList = getListsFromMap(surgery['procedures']);

    var vaccinationList =
        getSpecialListsFromMap(vaccination['vaccines'], "Vaccine", "Dosage");
    var programList = getSpecialListsFromMap(
        programAdmission['programs'], 'Program Name', 'Duration');
    var prescriptionList =
      getPrescriptionListsFromMap(prescription['prescriptions']);
    var reasonList = getSpecialListsFromMap(medicalVisit['reasonForVisit'], 'code', 'display')[0];


    var request = http.MultipartRequest(
        'POST', Uri.parse(hostname + '/patient/medical/visit'));
    var headers = {'Authorization': 'Bearer ${session.token}'};
    request.headers.addAll(headers);


    Map<String, String> imagingMap = imaging.isNotEmpty
        ? {
            'imaging_test': imagingList[0],
            'imaging_test_results': imagingList[1],
            'imaging_notes': jsonEncode([imaging['notes'] ?? ""]),
          }
        : {};

    Map<String, String> vitalMap = vitals.isNotEmpty
        ? {
            'vaital_blood_pressure':
                vitals['bloodPressureSystolic']?.toString() ?? "",
            'vaital_weight': vitals['weight']?.toString() ?? "",
            'vailtal_height': vitals['height']?.toString() ?? "",
            'vaital_temperature': vitals['temperature']?.toString() ?? "",
            'vaital_oxygen_saturation':
                vitals['oxygenSaturation']?.toString() ?? "",
            'vaital_notes': vitals['notes'] ?? "",
          }
        : {};
    Map<String, String> examMap = examination.isNotEmpty
        ? {
            'examination_history': jsonEncode([examination['history'] ?? ""]),
            'physical_examination': jsonEncode([examination['physicalExamination'] ?? ""]),
            'examination_assessment': jsonEncode([examination['assessment'] ?? ""]),
            'examination_giagnosis': examinationList,
            'examination_plan': jsonEncode([examination['plan'] ?? ""]),
            'examination_text': jsonEncode([examination['notes'] ?? ""]),
          }
        : {};
    Map<String, String> pathologyMap = pathology.isNotEmpty
        ? {
            'pathology_test': pathologyList[0],
            'pathology_test_results': pathologyList[1],
            'pathology_notes': jsonEncode([pathology['notes'] ?? ""]),
          }
        : {};
    Map<String, String> prescriptionMap = prescription.isNotEmpty
        ? {
            'prescriptions_drug': prescriptionList[0],
            'drug_code': prescriptionList[1],
            'prescriptions_dosage': prescriptionList[2],
            'prescriptions_notes': jsonEncode([prescription['notes'] ?? ""])
          }
        : {};
    Map<String, String> programAdmissionMap = programAdmission.isNotEmpty
        ? {
            'programs_names': programList[0],
            'programs_duration': programList[1],
            'programs_notes': jsonEncode([programAdmission['notes'] ?? ""])
          }
        : {};
    Map<String, String> radiologyMap = radiology.isNotEmpty
        ? {
            'radiology_test': radiologyList[0],
            'radiology_test_results': radiologyList[1],
            'radiology_notes': jsonEncode([radiology['notes'] ?? ""])
          }
        : {};
    print(radiologyMap);
    Map<String, String> surgeryMap = surgery.isNotEmpty
        ? {
            'surgery_test': surgeryList[0],
            'surgery_test_results': surgeryList[1],
            'surgery_notes': jsonEncode([surgery['notes'] ?? ""])
          }
        : {};
    Map<String, String> vaccinationMap = vaccination.isNotEmpty
        ? {
            'vaccine': vaccinationList[0],
            'dosage': vaccinationList[1],
            'vaccine_notes': jsonEncode([vaccination['notes'] ?? ""]),
          }
        : {};
    Map<String, String> vitalsMap = vitals.isNotEmpty
        ? {
            'vaital_blood_pressure':
                vitals['bloodPressureSystolic']?.toString() ?? "",
            'vaital_weight': vitals['weight']?.toString() ?? "",
            'vailtal_height': vitals['height']?.toString() ?? "",
            'vaital_temperature': vitals['temperature']?.toString() ?? "",
            'vaital_oxygen_saturation':
                vitals['oxygenSaturation']?.toString() ?? "",
            'vaital_notes': vitals['notes'] ?? "",
          }
        : {};
    Map<String, String> laboratoryMap = laboratory.isNotEmpty
        ? {
            'laboratory_test': laboratoryList[0],
            'laboratory_test_results': laboratoryList[1],
            'laboratory_notes': jsonEncode([laboratory['notes'] ?? ""]),
          }
        : {};
    request.fields.addAll({
      'latitude': latitude ?? "",
      'longitude': longitude ?? "",
      'visit_type': medicalVisit['visitType'] ?? "",
      'reasons_of_visit': reasonList,
      'visite_notes': medicalVisit['notes'] ?? "",
      'patient_id': patientId
    });
    request.fields.addAll(imagingMap);
    request.fields.addAll(vitalMap);
    request.fields.addAll(examMap);
    request.fields.addAll(pathologyMap);
    request.fields.addAll(prescriptionMap);
    request.fields.addAll(programAdmissionMap);
    request.fields.addAll(radiologyMap);
    request.fields.addAll(surgeryMap);
    request.fields.addAll(vaccinationMap);
    request.fields.addAll(vitalsMap);
    request.fields.addAll(laboratoryMap);

    final tempDir = await getTemporaryDirectory();
    List<List<File>> encounterFiles = [];
    encounterFiles.add(await getFiles(examination['files'] != null ? examination['files'] : null, tempDir, 'examination_attchment'));
    encounterFiles.add(await getFiles(laboratory['files'] != null ? laboratory['files'] : null, tempDir, 'laboratory_attachment'));
    encounterFiles.add(await getFiles(imaging['files'] != null ? imaging['files'] : null, tempDir, 'imaging_attachment'));
    encounterFiles.add(await getFiles(pathology['files'] != null ? pathology['files'] : null, tempDir, 'pathology_attachment'));
    encounterFiles.add(await getFiles(radiology['files'] != null ? radiology['files'] : null, tempDir, 'radiology_attachment'));
    encounterFiles.add(await getFiles(surgery['files'] != null ? surgery['files'] : null, tempDir, 'surgery_attachment'));
    encounterFiles.add(await getFiles(programAdmission['files'] != null ? programAdmission['files'] : null, tempDir, 'programs_attachment'));
    encounterFiles.add(await getFiles(vaccination['files'] != null ? vaccination['files'] : null, tempDir, 'vaccine_attachment'));
    for (var fileList in encounterFiles) {
      List<http.MultipartFile> fList = [];
      for (var file in fileList) {
        String name = file.path.split('/').last.split('.')[0];
        var f = await http.MultipartFile.fromPath(name, file.path);
        fList.add(f);
      }
      request.files.addAll(fList);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(await response.stream.bytesToString());
      return false;
    }
  }

  Future<List<File>> getFiles(
      List<dynamic>? fileData, Directory tempDir, String name) async {
    if (fileData == null) {
      return [];
    }
    List<File> files = [];
    for (int i = 0; i < fileData.length; i++) {
      List<int> bytes = await base64Decode(fileData[i]);
      String extension = getExtensionFromBytes(bytes);
      final f = File('${tempDir.path}/$name.$extension'); //${i.toString()}');
      await f.writeAsBytes(bytes);
      files.add(f);
    }
    return files;
  }

  Future<int> pushAllToServer(Session session) async {
    int successes = 0;
    List<Map<String, dynamic>> updates =
        await session.databaseHelper.getUpdates();
    for (var update in updates) {
      if (await sendServerUpdate(
          session, update['type'], update['id'], update['action'])) {
        successes++;
        session.databaseHelper.deleteUpdate(update['id']);
      }
    }
    return successes;
  }

  Future<bool> sendServerUpdate(Session session, String updateType,
      String updateId, String updateAction) async {
    if (updateType == UPDATE_TYPE.PATIENT) {
      if (updateAction == UPDATE_ACTION.CREATE) {
        Patient? p = await session.databaseHelper.getPatient(updateId);
        if (p != null) {
          String remoteId = await registerPatient(session, p);
          if (remoteId == ""){
            return false;
          }
          await session.databaseHelper.updatePatientToRemoteId(remoteId, p.patient_identity);
        } else {
          session.databaseHelper.deleteUpdate(updateId);
          print("sendServerUpdate: Patient not found");
          return false;
        }
        return true;
      } else if (updateAction == UPDATE_ACTION.UPDATE) {}
    } else if (updateType == UPDATE_TYPE.ENCOUNTER) {
      if (updateAction == UPDATE_ACTION.CREATE) {
        Map<String, String> visit =
            await session.databaseHelper.getVisit(updateId);
        if (visit.isEmpty) {
          print("sendServerUpdates: visit not found");
          return false;
        }
        Map<String, dynamic> encounterData =
            jsonDecode(visit['encounterData']!);
        Map<String, dynamic>? visitDetails =
            encounterData[COMPONENT_NAMES.MEDICAL_VISIT];
        return await addEncounter(
            session, encounterData, visit['patientId']!, visitDetails);
      }
    }
    return false;
  }

  Future<String> generatePatientId(Session session) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(hostname + '/patient/patient_id'));
    var headers = {'Authorization': 'Bearer ${session.token}'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    return "";
  }

}