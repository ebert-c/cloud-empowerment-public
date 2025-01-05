import 'dart:io';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/const.dart';
import '../util/util.dart';
import '../form_widgets/event_value_list.dart';
import '../form_widgets/file_picker_list.dart';

class VaccinationForm extends StatefulWidget {
  final Session session;
  VaccinationForm({Key? key, required this.session}) : super(key: key);

  @override
  _VaccinationFormState createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _vaccineOptions = [
    'Pfizer-BioNTech',
    'Moderna',
    'Johnson & Johnson',
    'AstraZeneca',
  ];
  final List<String> _dosageOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7'];

  Map<String, dynamic> values = {
    "vaccines": [],
    "files": [],
    "notes": "",
  };

  final List<File> files = [];
  List<Entry> vaccines = [];

  final textStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.VACCINATION] ?? values;
    vaccines = List.from(values['vaccines']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Vaccination/Immunization')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vaccine/Immunization', style: textStyle),
                      EventValueList(
                        event: "Vaccine",
                        value: "Dosage",
                        eventList: _vaccineOptions,
                        valueList: _dosageOptions,
                        entries: vaccines
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Text('Attach File', style: textStyle),
                      FileListWidget(values: values),
                      SizedBox(height: 10),
                      Text('Notes', style: textStyle),
                      TextFormField(
                          onChanged: (value) {
                            values["notes"] = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: textStyle,
                          ),
                          minLines: 4,
                          maxLines: null),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.save();
                            values["vaccines"] = vaccines;
                            widget.session.encounter?.addComponentData(COMPONENT_NAMES.VACCINATION, values);
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
