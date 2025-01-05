import 'dart:convert';

import 'package:cloudempowerment/util/const.dart';
import 'package:flutter/material.dart';

import '../model/patient_model.dart';
import '../model/session_model.dart';
import '../util/api.dart';
import '../util/util.dart';

class VisitView extends StatefulWidget {
  const VisitView({required this.session});

  final Session session;

  @override
  _VisitViewState createState() => _VisitViewState();
}

class _VisitViewState extends State<VisitView> {
  Session get session => widget.session;

  Patient get patient => session.getArg('patient');

  String get encounterId => session.getArg('encounterId');

  Map<String, String> visit = {};
  Map<String, dynamic> encounterData = {};
  Map<String, dynamic>? visitDetails = {};

  Future<void> _getVisit() async {
    visit = await session.databaseHelper.getVisit(encounterId);
    print(visit);
    encounterData = jsonDecode(visit['encounterData']!);
    visitDetails = encounterData[COMPONENT_NAMES.MEDICAL_VISIT];
    if (visitDetails != null) {
      encounterData.remove(COMPONENT_NAMES.MEDICAL_VISIT);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getVisit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Patient Visit"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundImage: patient.photo != null && patient.photo != ""
                                          ? DecorationImage(
                                          image: MemoryImage(
                                              base64.decode(
                                                  patient.photo ?? "")),
                                          fit: BoxFit.cover)
                                          .image
                                          : AssetImage("assets/anon_user.png"),
                                      radius: 30),
                                  SizedBox(width: 20),
                                  Text(
                                      '${patient.firstName} ${patient
                                          .lastName}',
                                      style: TextStyle(fontSize: 24)),
                                  // IconButton(
                                  //   icon: Icon(Icons.history),
                                  //   onPressed: (){
                                  //     ApiManager().addEncounter(session, encounterData, patient.patient_identity, visitDetails);
                                  //   }
                                  // )
                                ],
                              ),
                            )))
                  ]),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("VISIT HISTORY", style: TextStyle(fontSize: 24)),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed:  () =>  {
                          ApiManager().addEncounter(session, encounterData, visit['patientId']!, visitDetails)
                        },
                      )
                    ],
                  ),
                  Container(
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: visitDetails != null
                                ? [
                              VisitComponent(
                                  title: "Visit Details", data: visitDetails!)
                            ]
                                : []),
                        ...encounterData.entries.map((entry) {
                          final key = entry.key;
                          final value = entry.value;
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                VisitComponent(
                                    title: componentDisplayNames[key]!,
                                    data: value)
                              ]);
                        }).toList()
                      ])),
                ],
              ),
            )));
  }
}

class VisitComponent extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  VisitComponent({required this.title, required this.data});

  Map<String, List<String>> listTitles = {
    "prescriptions": ["Drug", "Dosage"],
    "vaccines": ["Vaccine", "Dosage"],
    "procedures": ["Test", "Result"],
    "programs": ["Program Name", "Duration"],
  };

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 300,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(height: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            Widget valueWidget = Text("");
            if (value is String) {
              valueWidget = Text(value, softWrap: true,);
            } else if (key == "files") {
              if (value.isNotEmpty) {
                valueWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.map<Widget>((base64String) {
                      FileType fileType = determineFileTypeFromBase64(
                          base64String);
                      if (fileType == FileType.img) {
                        return SizedBox(
                            height: 200,
                            width: 150,
                            child: Image.memory(
                                base64Decode(base64String), fit: BoxFit.cover));
                      } else {
                        return Text(base64String);
                      }
                    }).toList()
                );
              }
            } else if (value is List<dynamic>) {
              if (value.isNotEmpty) {
                if (value[0] is String) {
                  valueWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.map((string) => Text(string, softWrap: true,)).toList(),
                  );
                } else if (key == "diagnosis" || key == "reasonForVisit") {
                  valueWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.map((code) => Text(code['display'], softWrap: true,)).toList(),
                  );
                } else if (key == "prescriptions") {
                  valueWidget = Container(
                      width: 300,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Text("Drug", softWrap: true,)),
                                  Expanded(child: Text("Dosage", softWrap: true,))
                                ]),
                            ...value.map((entry) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(child: Text(entry['display'], softWrap: true,)),
                                    Expanded(child: Text(entry['dosage'], softWrap: true,))
                                  ]);
                            })
                          ]));
                }
                else {
                  String eventTitle = listTitles[key]![0];
                  String valueTitle = listTitles[key]![1];
                  valueWidget = Container(
                      width: 300,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(eventTitle)),
                                  Expanded(child: Text(valueTitle))
                                ]),
                            ...value.map((entry) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(child: Text(entry[eventTitle])),
                                    Expanded(child: Text(entry[valueTitle]))
                                  ]);
                            })
                          ]
                      )
                  );
                }
              }
            } else if(value == null){
              valueWidget = Text("");
            } else {
              valueWidget = Text(value.toString());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitComponentLabels[key]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                valueWidget,
              ],
            );
          }).toList(),
        ),
      ],
    ));
  }
}
