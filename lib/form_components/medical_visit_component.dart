import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/codings.dart';
import '../util/const.dart';
import '../form_widgets/date_time_form_field.dart';
import '../form_widgets/event_value_list.dart';
import '../form_widgets/location_field.dart';

class MedicalVisitForm extends StatefulWidget {
  final Session session;

  MedicalVisitForm({Key? key, required this.session}) : super(key: key);

  @override
  _MedicalVisitFormState createState() => _MedicalVisitFormState();
}

class _MedicalVisitFormState extends State<MedicalVisitForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime curTime = DateTime.now();
  Map<String, dynamic> values = {
    "provider": "",
    "dateTime": DateTime.now(),
    "gps": null,
    "visitType": "Home new visit",
    "reasonForVisit": [],
    "notes": ""
  };

  List<Map<String, dynamic>> options = SNOMED_CODES;
  List<Map<String, dynamic>> reasons = [];
  String location = "";
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  String buttonText = "Create Encounter";

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.MEDICAL_VISIT] ?? values;
    values["provider"] = widget.session.currentUser.getTitle();
    latitudeController.text = values['gps']?.split(" ")[1] ?? "";
    longitudeController.text = values['gps']?.split(" ")[3] ?? "";
    if (values['gps'] != null) {
      buttonText = "Save Changes";
    }
    reasons = List.from(values['reasonForVisit']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Medical Visit Form")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Provider",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: values["provider"],
                    onChanged: (value) {
                      setState(() {
                        values["provider"] = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  DateTimeFormField(),
                  SizedBox(height: 16.0),
                  Text("Reason for Visit"),
                  CodeList(options: options, entries: reasons,),
                  SizedBox(height: 16.0),
                  LocationField(longitudeController: longitudeController, latitudeController: latitudeController),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Visit Type",
                      border: OutlineInputBorder(),
                    ),
                    value: values['visitType'],
                    items: ["Home new visit", "Clinic new visit", "Home follow up", "Clinic follow up"]
                        .map((reason) => DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        values["visitType"] = value!;
                      });
                    },
                    onSaved: (value) {
                      values["visitType"] = value!;
                    }
                  ),
                  SizedBox(height: 16.0),
                  Text("Notes"),
                  TextFormField(
                    initialValue: values['notes'],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    minLines: 4,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        values["notes"] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        values['dateTime'] = values['dateTime'].toString();
                        values['reasonForVisit'] = reasons;
                        values['gps'] = 'Latitude: ${latitudeController.text} Longitude: ${longitudeController.text}';
                        widget.session.encounter?.addComponentData(
                            COMPONENT_NAMES.MEDICAL_VISIT, values);
                        Navigator.pop(context);
                      },
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
