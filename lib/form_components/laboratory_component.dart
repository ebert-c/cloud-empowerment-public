import 'dart:io';

import 'package:cloudempowerment/form_widgets/file_picker_list.dart';
import 'package:flutter/material.dart';

import '../model/session_model.dart';
import '../util/const.dart';
import '../form_widgets/event_value_list.dart';

Map<String, dynamic> labArgs = {
  "procedures": "",
  "files": [],
  "notes": ""
};

class LaboratoryForm extends StatefulWidget {
  final Session session;

  LaboratoryForm({Key? key, required this.session}) : super(key: key);

  @override
  _LaboratoryFormState createState() => _LaboratoryFormState();
}

class _LaboratoryFormState extends State<LaboratoryForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _testOptions = [
    'Blood test',
    'Urine test',
    'Stool test',
    'X-ray',
    'MRI',
  ];

  Map<String, dynamic> values = {
    "procedures": [],
    "files": [],
    "notes": "",
  };

  final List<File> files = [];
  List<dynamic> tests = [];

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.LABORATORY] ?? values;
    tests = List.from(values['procedures']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Laboratory')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Test'),
                      EventTextList(eventTitle: 'Test', textTitle: 'Result', events: _testOptions, entries: tests),
                      SizedBox(height: 10),
                      Text('Attach File'),
                      FileListWidget(values: values),
                      SizedBox(height: 10),
                      Text('Notes'),
                      TextFormField(
                        initialValue: values["notes"],
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        minLines: 4,
                        maxLines: null,
                        onChanged: (value) {
                          values["notes"] = value;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.save();
                            values["procedures"] = tests;
                            widget.session.encounter?.addComponentData(COMPONENT_NAMES.LABORATORY, values);
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
}
