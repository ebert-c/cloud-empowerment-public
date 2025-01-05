import 'dart:io';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/codings.dart';
import '../util/const.dart';
import '../form_widgets/event_value_list.dart';
import '../form_widgets/file_picker_list.dart';

class ExaminationForm extends StatefulWidget {
  final Session session;

  ExaminationForm({Key? key, required this.session}) : super(key: key);

  @override
  _ExaminationFormState createState() => _ExaminationFormState();
}

class _ExaminationFormState extends State<ExaminationForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> values = {
    "history": "",
    "physicalExamination": "",
    "assessment": "",
    "diagnosis": [],
    "plan": "",
    "files": [],
    "notes": ""
  };
  final List<File> files = [];
  List<Map<String, dynamic>> options = SNOMED_CODES;
  List<Map<String, dynamic>> diagnosis = [];

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.EXAMINATION] ?? values;
    diagnosis = List.from(values['diagnosis']);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Examination Form'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("History"),
                          TextFormField(
                            initialValue: values['history'],
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            minLines: 4,
                            maxLines: null,
                            onSaved: (value) {
                              values["history"] = value != null ? value : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text("Physical Examination"),
                          TextFormField(
                            initialValue: values["physicalExamination"],
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            minLines: 4,
                            maxLines: null,
                            onSaved: (value) {
                              values["physicalExamination"] =
                                  value != null ? value : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text("Assessment"),
                          TextFormField(
                            initialValue: values["assessment"],
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            minLines: 4,
                            maxLines: null,
                            onSaved: (value) {
                              values["assessment"] = value != null ? value : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text("Diagnosis"),
                          CodeList(options: options, entries: diagnosis,),
                          SizedBox(height: 16.0),
                          Text("Plan"),
                          TextFormField(
                            initialValue: values["plan"],
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            minLines: 4,
                            maxLines: null,
                            onSaved: (value) {
                              values["plan"] = value != null ? value : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text('Attachment:'),
                          FileListWidget(values: values),
                          SizedBox(height: 20),
                          Text('Notes:'),
                          TextFormField(
                            initialValue: values["notes"],
                            keyboardType: TextInputType.multiline,
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
                            minLines: 4,
                            maxLines: null,
                            onSaved: (value) {
                              values["notes"] = value != null ? value : "";
                            },
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _formKey.currentState?.save();
                                values['diagnosis'] = diagnosis;
                                widget.session.encounter?.addComponentData(
                                    COMPONENT_NAMES.EXAMINATION, values);
                                Navigator.pop(context);
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ])))));
  }
}
