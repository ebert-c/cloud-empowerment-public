import 'package:flutter/material.dart';

import '../model/session_model.dart';
import '../util/const.dart';

class VitalsForm extends StatefulWidget {
  final Session session;

  VitalsForm({Key? key, required this.session}) : super(key: key);

  @override
  _VitalsFormState createState() => _VitalsFormState();
}

class _VitalsFormState extends State<VitalsForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> values = {
    "bloodPressureSystolic": "",
    "bloodPressureDiastolic": "",
    "weight": "",
    "height": "",
    "temperature": "",
    "oxygenSaturation": "",
    "notes": "",
  };

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.VITALS] ?? values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Vitals Form'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: values["bloodPressureSystolic"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Blood Pressure Systolic(mmHg)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["bloodPressureSystolic"] =
                                  value != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: values["bloodPressureDiastolic"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Blood Pressure Diastolic(mmHg)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["bloodPressureDiastolic"] =
                                  value  != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: values["weight"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["weight"] =
                                  value  != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: values["height"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["height"] =
                                  value  != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: values["temperature"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Temperature (°C)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["temperature"] =
                                  value  != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: values["oxygenSaturation"],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Oxygen Saturation (%)',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["oxygenSaturation"] =
                                  value != "" ? double.parse(value!) : "";
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                              initialValue: values["notes"],
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Notes',
                              ),
                            onSaved: (value) {
                                values["notes"] = value;
                            }

                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _formKey.currentState?.save();
                                widget.session.encounter?.addComponentData(COMPONENT_NAMES.VITALS, values);
                                Navigator.pop(context);
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }
}
