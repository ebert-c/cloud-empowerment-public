import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/encounter_model.dart';
import '../util/const.dart';
import '../model/session_model.dart';
import '../util/widgets.dart';


final List<Map<String, String>> buttonLabels = [
  {'Visit Details': ROUTES.MEDICAL_VISIT},
  {'Vitals': ROUTES.VITALS},
  {'Examination': ROUTES.EXAMINATION},
  {'Imaging': ROUTES.IMAGING},
  {'Laboratory': ROUTES.LABORATORY},
  {'Pathology': ROUTES.PATHOLOGY},
  {'Radiology': ROUTES.RADIOLOGY},
  {'Surgery': ROUTES.SURGERY},
  {'Vaccination/Immunization': ROUTES.VACCINATION},
  {'Programs/Admissions': ROUTES.PROGRAM_ADMISSION},
  {'Prescriptions': ROUTES.PRESCRIPTION},
];


class AddEncounter extends StatefulWidget {
  final Session session;

  AddEncounter({required this.session});

  @override
  _EncounterViewState createState() => _EncounterViewState();
}


class _EncounterViewState extends State<AddEncounter> {
  get session => widget.session;
  Map<String, bool> dataMap =
  {'Visit Details': true,
    'Vitals': false,
    'Examination': false,
    'Imaging': false,
    'Laboratory': false,
    'Pathology': false,
    'Radiology': false,
    'Surgery': false,
    'Vaccination/Immunization': false,
    'Programs/Admissions': false,
    'Prescriptions': false,
  };
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final buttons = buttonLabels.map((button) {
      String label = button.keys.toList().first;
      String route = button[label]!;
      return ListTile(
        onTap: () {
          setState(() {
            dataMap[label] = true;
          });
          Navigator.of(context).pushNamed(route, arguments: session);
        },
        leading: CircleAvatar(
          backgroundColor: dataMap[label]! ? Colors.green : Colors.red,
          child: dataMap[label]! ?
              Icon(Icons.check, color: Colors.white)
              : Icon(
            Icons.indeterminate_check_box,
            color: Colors.white
          )
        ),
        title: Text(label),
      );
    });
    Encounter encounter = session.encounter!;
    return WillPopScope(
        onWillPop: () async {
          bool confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm'),
                content: Text('Warning, leaving this page without submitting will delete current encounter data? \nAre you sure you wish to leave?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
          return confirm;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Encounter'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage: encounter.patient.photo != null &&
                                  encounter.patient.photo != ""
                              ? DecorationImage(
                                      image: MemoryImage(base64.decode(
                                          encounter.patient.photo ?? "")),
                                      fit: BoxFit.cover)
                                  .image
                              : AssetImage("assets/anon_user.png"),
                          radius: 30),
                      SizedBox(width: 16),
                      Text(
                        '${encounter.patient.firstName} ${encounter.patient.lastName}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text(
                                'Are you sure you wish to submit?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  OverlayEntry _overlayEntry = createOverlayEntry();
                                  Overlay.of(context)?.insert(_overlayEntry);
                                  bool success = await encounter.saveEncounter(session);
                                  if (success) {
                                    showToast("Encounter has been saved to the web.");
                                  } else {
                                    showToast("Encounter saved to local device. Connect to the internet and push updates to save to web.");
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _overlayEntry.remove();
                                },
                              ),
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Submit"),
                  )
                ]),
                ...buttons,
                SizedBox(height: 24),
              ],
            ),
          ),
        ));
  }
}

