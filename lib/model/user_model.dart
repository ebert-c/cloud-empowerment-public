import 'package:cloudempowerment/model/patient_model.dart';
import 'package:cloudempowerment/model/session_model.dart';
import 'package:cloudempowerment/util/const.dart';
import 'package:json_annotation/json_annotation.dart';

import '../util/api.dart';
import '../util/util.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String first_name;
  String last_name;
  String? user_id;
  String identity_id;
  String email;
  String photo;
  String gender;
  String phone;
  String address;
  String designation;
  String? role;

  User(
      {required this.first_name,
      required this.last_name,
      this.user_id,
      required this.identity_id,
      required this.email,
      String? photo,
      required this.gender,
      required this.phone,
      required this.address,
      required this.designation,
      this.role})
      : this.photo = photo ?? "";

  String getTitle() {
    return "$designation $last_name";
  }

  String getFullNameInverted() {
    return "$last_name $first_name";
  }

  factory User.fromLocalJson(Map<String, dynamic> json) {
    User user = _$UserFromJson(json);
    return user;
  }

  factory User.fromRemoteJson(Map<String, dynamic> json) {
    User user = User(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      user_id: json['user_id'] as String?,
      identity_id: (json['idetity_id'] as int).toString(),
      email: json['email'] as String,
      photo: json['photo'] as String?,
      gender: json['gender'] as String,
      phone: (json['phone']).toString(),
      address: json['address'] as String,
      designation: json['designation'] as String,
      role: json['role'] as String?,
    );
    return user;
  }

  Map<String, dynamic> toLocalJson() {
    Map<String, dynamic> userJson = _$UserToJson(this);
    return userJson;
  }

  Map<String, dynamic> toRemoteJson() {
    Map<String, dynamic> userJson = {
      'first_name': this.first_name,
      'last_name': this.last_name,
      'user_id': this.user_id,
      'idetity_id': this.identity_id,
      'email': this.email,
      'gender': this.gender,
      'phone': this.phone,
      'address': this.address,
      'designation': this.designation,
    };
    return userJson;
  }

  Future<bool> addPatient(Patient p, Session session) async {
    try {
      bool remoteAdded = false;
      String remoteId = "";
      if (await AppConnectivity.isConnected()) {
        remoteId = await ApiManager().registerPatient(session, p);
        remoteAdded = remoteId.isNotEmpty;
        if (remoteId.isNotEmpty) {
          p.patient_identity = remoteId;
          showToast("Patient saved to web.");
        }
      }
      await session.databaseHelper
          .insertObjectToUserDatabase(p, DATABASE_TABLE_NAMES.PATIENTS_TABLE);
      if (!remoteAdded) {
        await session.databaseHelper.addUpdate(p.patient_identity, UPDATE_TYPE.PATIENT, UPDATE_ACTION.CREATE);
        showToast("Patient saved locally, connect to the internet to sync to web.");
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> insertPatientFromRemote(Patient p, Session session) async {
    try {
      await session.databaseHelper
          .insertObjectToUserDatabase(p, DATABASE_TABLE_NAMES.PATIENTS_TABLE);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser(Session session) async {
    try {
      await session.databaseHelper.updateUser(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  void invalidate() {
    this.first_name = "";
    this.last_name = "";
    this.user_id = "";
    this.identity_id = "";
    this.email = "";
    this.photo = "";
    this.gender = "";
    this.phone = "";
    this.address = "";
    this.designation = "";
    this.role = "";
  }
}
