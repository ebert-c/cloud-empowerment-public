// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      doctor_id: json['doctor_id'] as String,
      patient_identity: json['patient_identity'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthday: json['birthday'] as String,
      bloodGroup: json['bloodGroup'] as String?,
      gender: json['gender'] as String?,
      insurance_number: json['insurance_number'] as String?,
      insurance_provider: json['insurance_provider'] as String?,
      contact_address: json['contact_address'] as String?,
      mailing_address: json['mailing_address'] as String?,
      phone_number: json['phone_number'] as String?,
      email_address: json['email_address'] as String?,
      nok_name: json['nok_name'] as String?,
      nokin_address: json['nokin_address'] as String?,
      nok_relationship: json['nok_relationship'] as String?,
      nok_phone: json['nok_phone'] as String?,
      nok_email: json['nok_email'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'doctor_id': instance.doctor_id,
      'patient_identity': instance.patient_identity,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday,
      'bloodGroup': instance.bloodGroup,
      'gender': instance.gender,
      'photo': instance.photo,
      'insurance_number': instance.insurance_number,
      'insurance_provider': instance.insurance_provider,
      'contact_address': instance.contact_address,
      'mailing_address': instance.mailing_address,
      'phone_number': instance.phone_number,
      'email_address': instance.email_address,
      'nok_name': instance.nok_name,
      'nokin_address': instance.nokin_address,
      'nok_relationship': instance.nok_relationship,
      'nok_phone': instance.nok_phone,
      'nok_email': instance.nok_email,
    };
