import 'dart:core';
import 'package:cloudempowerment/model/session_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../util/const.dart';
import '../util/util.dart';
part 'patient_model.g.dart';

@JsonSerializable()
class Patient {
  String doctor_id;
  String patient_identity;
  String firstName;
  String lastName;

  String birthday;

  String? bloodGroup;
  String? gender;
  String? photo;
  String? insurance_number;
  String? insurance_provider;

  String? contact_address;
  String? mailing_address;
  String? phone_number;
  String? email_address;

  String? nok_name;
  String? nokin_address;
  String? nok_relationship;
  String? nok_phone;
  String? nok_email;

  Patient({
    required this.doctor_id,
    required this.patient_identity,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    this.bloodGroup,
    this.gender,
    this.insurance_number,
    this.insurance_provider,
    this.contact_address,
    this.mailing_address,
    this.phone_number,
    this.email_address,
    this.nok_name,
    this.nokin_address,
    this.nok_relationship,
    this.nok_phone,
    this.nok_email,
    String? photo
  }) : this.photo = photo ?? "";

  @override
  String toString() {
    return "${this.firstName} ${this.lastName}";
  }

  factory Patient.fromLocalJson(Map<String, dynamic> json){
    Patient patient = _$PatientFromJson(json);
    return patient;
  }

  factory Patient.fromRemoteJson(Map<String, dynamic> json) {
    return Patient(
      doctor_id: json['doctor_id'].toString(),
      patient_identity: json['patient_identity'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthday: json['birthday'] as String,
      bloodGroup: json['blod_group'] as String?,
      gender: json['gender'] as String?,
      insurance_number: json['insurance_number'].toString(),
      insurance_provider: json['insurance_provider'] as String?,
      contact_address: json['contact_address'] as String?,
      mailing_address: json['mailing_address'] as String?,
      phone_number: json['phone_number']?.toString(),
      email_address: json['email_address'] as String?,
      nok_name: json['nok_name'] as String?,
      nokin_address: json['nokin_address'] as String?,
      nok_relationship: json['nok_relationship'] as String?,
      nok_phone: json['nok_phone']?.toString(),
      nok_email: json['nok_email'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toLocalJson() {
    Map<String, dynamic> json = _$PatientToJson(this);
    return json;
  }

  int getAge() {
    return Util.calculateAge(DateTime.parse(this.birthday));
  }

  Map<String, String> toRemoteJson() {
    Map<String, String> remoteJson = {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'birthday': this.birthday,
      'blod_group': this.bloodGroup ?? "",
      'gender': this.gender ?? "",
      'insurance_number': this.insurance_number ?? "",
      'insurance_provider': this.insurance_provider ?? "",
      'contact_address': this.contact_address ?? "",
      'mailing_address': this.mailing_address ?? "",
      'phone_number': this.phone_number ?? "",
      'email_address': this.email_address ?? "",
      'nok_name': this.nok_name ?? "",
      'nokin_address': this.nokin_address ?? "",
      'nok_relationship': this.nok_relationship ?? "",
      'nok_phone': this.nok_phone ?? "",
      'nok_email': this.nok_email ?? "",
    };
    return remoteJson;
  }



  Future<void> mergeNewJson(Map<String, dynamic> newJson, Session session) async {
    await session.databaseHelper.insertObjectToUserDatabase(this, DATABASE_TABLE_NAMES.PATIENTS_TABLE);
  }
}
