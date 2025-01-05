import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class COLORS {
  static const Color RED = Color(0xFFC92A0D);
  static const Color BLACK = Colors.black;
  static const Color TRANSPARENT = Colors.transparent;
  static const Color BLUE = Colors.blue;
  static const Color GREEN = Colors.green;
  static const Color WHITE = Colors.white;
  static final Color TEXT_RED = Colors.red.shade900;
  static final Color TEXT_BLUE = Colors.blue.shade900;
  static const Color GREY = Colors.grey;
  static final Color LIGHT_GREY = Colors.grey.shade300;
  static final Color DARK_GREY = Colors.grey.shade700;
  static final Color DARKEST_GREY = Colors.grey.shade900;
  static const Color GREEN_ACCENT = Colors.greenAccent;
}

class DATABASE_SCHEMAS {
  static const String CREATE_USER_TABLE =
      'CREATE TABLE user(identity_id TEXT PRIMARY KEY, last_name TEXT, user_id TEXT, first_name TEXT, email TEXT, photo TEXT, gender TEXT, phone TEXT, address TEXT, designation TEXT, role TEXT)';
  static const String CREATE_PATIENTS_TABLE =
      'CREATE TABLE patients(patient_identity TEXT PRIMARY KEY, doctor_id TEXT, firstName TEXT, lastName TEXT, birthday TEXT, bloodGroup TEXT, gender TEXT, photo TEXT, insurance_number TEXT, insurance_provider TEXT, contact_address TEXT, mailing_address TEXT, phone_number TEXT, email_address TEXT, nok_name TEXT, nokin_address TEXT, nok_relationship TEXT, nok_phone TEXT, nok_email TEXT)';
  static const String CREATE_LOGIN_TABLE =
      'CREATE TABLE users(userId TEXT PRIMARY KEY, databaseId TEXT)';
  static const String CREATE_MESSAGES_TABLE =
      'CREATE TABLE messages(msgId TEXT PRIMARY KEY, chatID KEY, timestamp TEXT, text TEXT, senderID TEXT)';
  static const String CREATE_CREDENTIALS_TABLE =
      'CREATE TABLE credentials(token TEXT PRIMARY KEY)';
  static const String CREATE_FORMS_TABLE =
      'CREATE TABLE forms(formId TEXT PRIMARY KEY, name TEXT, description TEXT, components TEXT)';
  static const String CREATE_HISTORY_TABLE =
      'CREATE TABLE history(encounterId TEXT PRIMARY KEY, patientId TEXT, providerName TEXT, encounterData TEXT)';
  static const String CREATE_UPDATES_TABLE =
      'CREATE TABLE updates(id TEXT PRIMARY KEY, type TEXT, action TEXT)';
}

class UPDATE_TYPE {
  static const String PATIENT = 'patient';
  static const String ENCOUNTER = 'encounter';
}

class UPDATE_ACTION {
  static const String CREATE = 'create';
  static const String UPDATE = 'update';
}

class DATABASE_TABLE_NAMES {
  static const String USER_TABLE = 'user';
  static const String PATIENTS_TABLE = 'patients';
  static const String CHATS_TABLE = 'chats';
  static const String USERS_TABLE = 'users';
  static const String FORMS_TABLE = 'forms';
  static const String HISTORY_TABLE = 'history';
  static const String UPDATES_TABLE = 'updates';
}

class LIST_NAMES {
  static const String COMPLETED_FORMS = "completedForms";
  static const String FORM_TEMPLATES = "formTemplates";
  static const String PATIENTS = "patients";
  static const String CHATS = "chats";
  static const String INPUT_IDS = "inputIDs";
  static const String DATA = "data";
}

class FORM_TYPES {
  static const String CLINICAL = "CLINICAL";
  static const String LAB_IMAGING = "LAB_OR_IMAGING";
  static const String ADMISSION = "ADMISSION";
  static const String PROGRAMS = "PROGRAMS";
  static const String MEDICATION = "MEDICATION";
  static const String COVID_SCREENING = "COVID_SCREENING";
}



class STRINGS {
  static const String ACCOUNT = "Account";
  static const String ADDRESS = "Address:";
  static const String ADD_PATIENT = "Add Patient";
  static const String ADD_RECORD = "Add Record";
  static const String ADMISSION = "Admission";
  static const String ADD_MEDICAL_INFO = "Add Medical Info";
  static const String AGE = "Age:";
  static const String BACK_TO_DASHBOARD = "Back to Dashboard";
  static const String BACK = "Back";
  static const String CANCEL = "Cancel";
  static const String CHOOSE_FORM_TEMPLATE = "Choose Form Template";
  static const String CHOOSE_RECORD_TO_ADD = "Choose Record to Add";
  static const String CHOOSE_FORM = "Choose Form";
  static const String CLINICALS = "Clinicals";
  static const String COMPLAINTS = "Complaints";
  static const String CONNECTION = "Connection";
  static const String COVID_SCREENING = "COVID Screening";
  static const String DOB = "DOB:";
  static const String EDIT = "Edit";
  static const String EDIT_MY_PROFILE = "Edit My Profile";
  static const String ENTER_PATIENT_INFORMATION =
      "Enter patient information and registration info";
  static const String EXAMINATION = "Examination";
  static const String FIRST_NAME = "First Name";
  static const String FORGOT_PASSWORD = "Forgot Password?";
  static const String HI_THERE_NICE_TO_SEE_YOU_AGAIN =
      "Hi there! Nice to see you again.";
  static const String HOME = "Home";
  static const String LAB_IMAGING = "Lab/Imaging";
  static const String LAST_NAME = "Last Name";
  static const String LOADING = "Loading...";
  static const String LOGOUT = "Logout";
  static const String LOGOUT_FAILED = "Logout Failed";
  static const String MEDICATION = "Medication";
  static const String MEDICAL_HISTORY = "Medical History";
  static const String NEW_PATIENT = 'New Patient';
  static const String PASSWORD = "Password";
  static const String PATIENT_INFO = "Patient Info";
  static const String PATIENTS = "Patients";
  static const String PREFIX = "Prefix";
  static const String PROGRAMS = "Programs";
  static const String REGISTER_NEW_PATIENT = "Register New Patient";
  static const String REGISTERED_PATIENTS = "Registered Patients";
  static const String SAVE_CAPS = "SAVE";
  static const String SAVE = "Save";
  static const String SEARCH = "Search";
  static const String SEARCH_FORMS = "Search forms";
  static const String SEX = "Sex:";
  static const String SHARE_PATIENT_INFO = "Share Patient Info";
  static const String SIGN_IN = "Sign In";
  static const String TAKE_PICTURE = "Take Picture";
  static const String UPLOAD_PICTURE = "Upload Picture";
  static const String UPLOAD_DATA = "Upload Data";
  static const String DOWNLOAD_DATA = "Download Data";
  static const String USERNAME = "Username";
  static const String VIEW_PATIENTS = "View Patients";
  static const String VIEW_REPORTS = "View Reports";
  static const String VITALS = "Vitals";
  static const String WELCOME_TO_THE_ZIMCAN_HEALTH_APP =
      "Welcome to the Zimcan Health app";
  static const String EDIT_PICTURE = "Edit Picture";
  static const String UPLOAD_FAILED = "Upload failed, check network connection";
  static const String DOWNLOAD_FAILED =
      "Download failed, check network connection";
  static const String UPLOAD_SUCCEEDED = "Data successfully uploaded";
  static const String DOWNLOAD_SUCCEEDED = "Data successfully downloaded";
  static const String OFFLINE_MODE_NOTIFICATION = "Currently in offline mode";
  static const String INVALID_CREDENTIALS = "Invalid credentials";
  static const String ERROR_RETRIEVING_PATIENT_DATA =
      "Error retrieving patient data from database";
  static const String ERROR_RETRIEVING_TEMPLATE_DATA =
      "Error retrieving template data from database";
}

class ROUTES {
  static const String LOGIN = '/';
  static const String HOME = '/home';
  static const String ADD_PATIENT = '/add-patient';
  static const String ADD_RECORD = '/add-record';
  static const String PATIENT_INFO = '/patient-info';
  static const String PATIENT_LIST = '/patient-list';
  static const String REPORTS = '/reports';
  static const String ADD_CLINICAL = '/add-clinical';
  static const String EDIT_PROFILE = '/edit-profile';
  static const String PATIENT_PROFILE = '/patient-profile';
  static const String SETTINGS = '/settings';
  static const String CHOOSE_FORM_TEMPLATE = '/choose-form-template';
  static const String PATIENT_HISTORY = '/patient-history-view';
  static const String PROGRAM_ADMISSION = '/program-admission';
  static const String EXAMINATION = '/examination';
  static const String IMAGING = '/imaging';
  static const String LABORATORY = '/laboratory';
  static const String MEDICAL_VISIT = '/medical-visit';
  static const String PATHOLOGY = '/pathology';
  static const String PRESCRIPTION = '/prescription';
  static const String RADIOLOGY = '/radiology';
  static const String SURGERY = '/surgery';
  static const String VACCINATION = '/vaccination';
  static const String VITALS = '/vitals';
  static const String ADD_ENCOUNTER = '/add-encounter';
  static const String VIEW_FORM = '/view-form';
  static const String EDIT_PATIENT = '/edit-patient';
  static const String VISIT = '/visit';
  static const String DOCUMENTS = '/documents';
}

class COMPONENT_NAMES {
  static const String ADD_PATIENT = "add-patient";
  static const String PROGRAM_ADMISSION = "program-admission";
  static const String EXAMINATION = "examination";
  static const String IMAGING = "imaging";
  static const String LABORATORY = "laboratory";
  static const String MEDICAL_VISIT = "medical-visit";
  static const String PATHOLOGY = "pathology";
  static const String PRESCRIPTION = "prescription";
  static const String RADIOLOGY = "radiology";
  static const String SURGERY = "surgery";
  static const String VACCINATION = "vaccination";
  static const String VITALS = "vitals";
  static const String ADD_ENCOUNTER = "add-encounter";
  static const String DOCUMENTS = "documents";
  static const String PATIENT_LIST = "patient-list";
  static const String REPORTS = "reports";

}

const List<String> BLOOD_TYPES = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

const List<String> GENDERS = ['Male', 'Female'];

const Map<String, IconData> COMPONENT_ICONS = {
  COMPONENT_NAMES.ADD_PATIENT: Icons.person_add_alt_rounded,
  COMPONENT_NAMES.DOCUMENTS: Icons.description,
  COMPONENT_NAMES.PATIENT_LIST: Icons.people,
  COMPONENT_NAMES.REPORTS: Icons.assessment,
};

const Map<String, String> componentDisplayNames = {
  "add-patient": "Add Patient",
  "program-admission": "Program Admission",
  "examination": "Examination",
  "imaging": "Imaging",
  "laboratory": "Laboratory",
  "medical-visit": "Medical Visit",
  "pathology": "Pathology",
  "prescription": "Prescription",
  "radiology": "Radiology",
  "surgery": "Surgery",
  "vaccination": "Vaccination",
  "vitals": "Vitals",
  "documents": "Documents",
  "patient-list": "Patient List",
  "reports": "Reports",
};

Map<String, String> visitComponentLabels = {
  "programName": "Program Name",
  "selectedDosage": "Selected Dosage",
  "prescriptions": "Prescriptions",
  "files": "Files",
  "notes": "Notes",
  "history": "History",
  "physicalExamination": "Physical Examination",
  "assessment": "Assessment",
  "diagnosis": "Diagnosis",
  "plan": "Plan",
  "attachment": "Attachment",
  "selectedTest": "Selected Test",
  "testResults": "Test Results",
  "attachFile": "Attach File",
  "provider": "Provider",
  "dateTime": "Date Time",
  "gps": "GPS",
  "visitType": "Visit Type",
  "reasonForVisit": "Reason for Visit",
  "selectedDrug": "Selected Drug",
  "procedure": "Procedure",
  "results": "Results",
  "selectedVaccine": "Selected Vaccine",
  "bloodPressureSystolic": "Blood Pressure Systolic(mmHg)",
  "bloodPressureDiastolic": "Blood Pressure Diastolic(mmHg)",
  "weight": "Weight(kg)",
  "height": "Height(cm)",
  "temperature": "Temperature(°C)",
  "oxygenSaturation": "Oxygen Saturation(%)",
  "vaccines": "Vaccines",
  "procedures": "Procedures",
  "programs": "Programs"
};

RegExp _phoneRegExp = RegExp(r'^\d{0,10}$');

List<TextInputFormatter> NUMERICAL_INPUT = [
  FilteringTextInputFormatter.allow(_phoneRegExp)
];

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: COLORS.RED,
    textColor: COLORS.WHITE,
    fontSize: 16.0,
  );
}
