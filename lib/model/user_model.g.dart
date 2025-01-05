// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      user_id: json['user_id'] as String?,
      identity_id: json['identity_id'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String?,
      gender: json['gender'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      designation: json['designation'] as String,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'user_id': instance.user_id,
      'identity_id': instance.identity_id,
      'email': instance.email,
      'photo': instance.photo,
      'gender': instance.gender,
      'phone': instance.phone,
      'address': instance.address,
      'designation': instance.designation,
      'role': instance.role,
    };
