import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/codings.dart';
import '../util/const.dart';
import '../form_widgets/event_value_list.dart';

class PrescriptionForm extends StatefulWidget {
  final Session session;

  PrescriptionForm({Key? key, required this.session}) : super(key: key);

  @override
  _PrescriptionFormState createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _drugOptions = DRUG_CODES;
  Map<String, dynamic> values = {
    "prescriptions": [],
    "files": [],
    "notes": ""
  };
  List<Map<String, dynamic>> prescriptions = [];

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.PRESCRIPTION] ?? values;
    prescriptions = List.from(values['prescriptions']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Prescription')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prescription'),
                      PrescriptionList(options: _drugOptions, entries: prescriptions),
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
                            values["prescriptions"] = prescriptions;
                            widget.session.encounter?.addComponentData(COMPONENT_NAMES.PRESCRIPTION, values);
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
