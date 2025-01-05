import 'dart:io';
import 'package:cloudempowerment/form_components/imaging_component.dart';
import 'package:cloudempowerment/form_components/laboratory_component.dart';
import 'package:cloudempowerment/form_components/medical_visit_component.dart';
import 'package:cloudempowerment/form_components/pathology_component.dart';
import 'package:cloudempowerment/form_components/prescription_component.dart';
import 'package:cloudempowerment/form_components/radiology_component.dart';
import 'package:cloudempowerment/util/const.dart';
import 'package:cloudempowerment/util/util.dart';
import 'package:cloudempowerment/view/add_patient_view.dart';
import 'package:cloudempowerment/view/add_encounter_view.dart';
import 'package:cloudempowerment/view/document_library_view.dart';
import 'package:cloudempowerment/view/edit_profile_view.dart';
import 'package:cloudempowerment/view/home_view.dart';
import 'package:cloudempowerment/view/login_view.dart';
import 'package:cloudempowerment/view/patient_history_view.dart';
import 'package:cloudempowerment/view/patient_info_view.dart';
import 'package:cloudempowerment/view/patient_list_view.dart';
import 'package:cloudempowerment/view/reports_view.dart';
import 'package:cloudempowerment/view/visit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_components/admission_component.dart';
import 'form_components/edit_patient_component.dart';
import 'form_components/examination_component.dart';
import 'form_components/surgery_component.dart';
import 'form_components/vaccination_component.dart';
import 'form_components/vitals_component.dart';
import 'model/session_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

Future<void> createDocumentsFolder() async {
  String folderPath = await getDocumentsPath();
  Directory documentsDir = Directory(folderPath);
  if (!await documentsDir.exists()) {
    documentsDir.create(recursive: true);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    createDocumentsFolder();
    return MaterialApp(
      title: 'Cloud Empowerment',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        ROUTES.RADIOLOGY: (BuildContext context) =>
            RadiologyForm(session: getSession(context)),
        ROUTES.ADD_ENCOUNTER: (BuildContext context) =>
            AddEncounter(session: getSession(context)),
        ROUTES.PRESCRIPTION: (BuildContext context) =>
            PrescriptionForm(session: getSession(context)),
        ROUTES.VITALS: (BuildContext context) =>
            VitalsForm(session: getSession(context)),
        ROUTES.VACCINATION: (BuildContext context) =>
            VaccinationForm(session: getSession(context)),
        ROUTES.SURGERY: (BuildContext context) =>
            SurgeryForm(session: getSession(context)),
        ROUTES.PATHOLOGY: (BuildContext context) =>
            PathologyForm(session: getSession(context)),
        ROUTES.LABORATORY: (BuildContext context) =>
            LaboratoryForm(session: getSession(context)),
        ROUTES.IMAGING: (BuildContext context) =>
            ImagingForm(session: getSession(context)),
        ROUTES.MEDICAL_VISIT: (BuildContext context) =>
            MedicalVisitForm(session: getSession(context)),
        ROUTES.PROGRAM_ADMISSION: (BuildContext context) =>
            ProgramForm(session: getSession(context)),
        ROUTES.EXAMINATION: (BuildContext context) =>
            ExaminationForm(session: getSession(context)),
        ROUTES.HOME: (BuildContext context) =>
            HomeView(session: getSession(context)),
        ROUTES.ADD_PATIENT: (BuildContext context) =>
            AddPatientView(session: getSession(context)),
        ROUTES.PATIENT_INFO: (BuildContext context) =>
            PatientInfoView(session: getSession(context)),
        ROUTES.PATIENT_LIST: (BuildContext context) =>
            PatientListView(session: getSession(context)),
        ROUTES.REPORTS: (BuildContext context) => ReportsView(),
        ROUTES.PATIENT_HISTORY: (BuildContext context) =>
            PatientHistoryView(session: getSession(context)),
        ROUTES.EDIT_PROFILE: (BuildContext context) =>
            EditProfileView(session: getSession(context)),
        ROUTES.EDIT_PATIENT: (BuildContext context) =>
            EditPatientView(session: getSession(context)),
        ROUTES.VISIT: (BuildContext context) =>
            VisitView(session: getSession(context)),
        ROUTES.DOCUMENTS: (BuildContext context) =>
            DocumentsLibraryView(session: getSession(context))
      },
    );
  }

  Session getSession(BuildContext context) {
    return ModalRoute.of(context)!.settings.arguments as Session;
  }
}
