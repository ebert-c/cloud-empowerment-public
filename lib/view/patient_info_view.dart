import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/encounter_model.dart';
import '../model/patient_model.dart';
import '../model/session_model.dart';
import '../util/const.dart';

class PatientInfoView extends StatefulWidget {
  const PatientInfoView({required this.session});

  final Session session;

  @override
  _PatientInfoViewState createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  String get patientId => widget.session.getArg('patientId');
  Patient? patient;
  get session => widget.session;

  String getTimeSince(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    final weeks = (difference.inDays % 365) % 30 ~/ 7;
    final yearString = years == 1 ? 'year' : 'years';
    final monthString = months == 1 ? 'month' : 'months';
    final weekString = weeks == 1 ? 'week' : 'weeks';

    return '$years $yearString, $months $monthString, and $weeks $weekString';
  }

  final double spacingHeight = 18.0;

  Future<void> _setPatient() async {
    patient = await widget.session.databaseHelper.getPatient(patientId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _setPatient();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Patient Info"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: patient == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      backgroundImage: patient?.photo != null && patient?.photo != "" ? DecorationImage(
                                          image: MemoryImage(base64.decode(patient?.photo ?? "")),
                                        fit: BoxFit.cover
                                      ).image
                                          : AssetImage("assets/anon_user.png"),
                                      radius: 30),
                                  Column(children: [
                                    // IconButton(
                                    //     icon: Icon(Icons.edit),
                                    //     onPressed: () {
                                    //       widget.session
                                    //           .addArg('patient', patient);
                                    //       Navigator.of(context).pushNamed(
                                    //           ROUTES.EDIT_PATIENT,
                                    //           arguments: widget.session);
                                    //     }),
                                    // Text("Edit")
                                  ])
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  '${patient?.firstName} ${patient?.lastName}'),
                              SizedBox(height: spacingHeight),
                              Text('ID: ${patient?.patient_identity}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                  'Date of Birth: ${patient?.birthday.toString().substring(0, 10)}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                  'Age: ${getTimeSince(DateTime.parse(patient!.birthday))}'),
                              SizedBox(height: spacingHeight),
                              Text('Blood Type: ${patient?.bloodGroup}'),
                              SizedBox(height: spacingHeight),
                              Text('Gender: ${patient?.gender}'),
                              SizedBox(height: spacingHeight),
                              Text('Insurance Number: ${patient?.insurance_number}'),
                              SizedBox(height: spacingHeight),
                              Text('Insurance Provider: ${patient?.insurance_provider}'),
                              SizedBox(height: spacingHeight),

                              Text(
                                  'Mailing Address: ${patient?.mailing_address}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                  'Contact Address: ${patient?.contact_address}'),
                              SizedBox(height: spacingHeight),
                              Text('Phone Number: ${patient?.phone_number}'),
                              SizedBox(height: spacingHeight),
                              Text('Email Address: ${patient?.email_address}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                'Next of Kin',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(height: spacingHeight),
                              Text('Name: ${patient?.nok_name}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                  'Contact Address: ${patient?.nokin_address}'),
                              SizedBox(height: spacingHeight),
                              Text('Phone Number: ${patient?.nok_phone}'),
                              SizedBox(height: spacingHeight),
                              Text('Email Address: ${patient?.nok_email}'),
                              SizedBox(height: spacingHeight),
                              Text(
                                  'Relationship: ${patient?.nok_relationship}'),
                            ],
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children:[
                              IconButton(
                                onPressed: () {
                                  session.encounter = new Encounter(
                                  provider: widget.session.currentUser,
                                  patient: patient!
                                  );
                                  Navigator.of(context).pushNamed(
                                      ROUTES.ADD_ENCOUNTER,
                                      arguments: widget.session);
                                  Navigator.of(context).pushNamed(
                                      ROUTES.MEDICAL_VISIT,
                                      arguments: widget.session);
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.red,
                                  size: 35
                                ),
                              ),
                              Text('Add Visit')
                          ]),
                          Column(
                              children:[
                                IconButton(
                                  onPressed: () {
                                    widget.session.setArgs({
                                      'patient': patient
                                    });
                                    Navigator.of(context).pushNamed(
                                        ROUTES.PATIENT_HISTORY,
                                        arguments: widget.session);
                                  },
                                  icon: Icon(
                                      Icons.history,
                                      size: 35
                                  ),
                                ),
                                Text('View History')
                              ]),
                        ],
                      )]
                    )
                )
        )
    );
  }
}
