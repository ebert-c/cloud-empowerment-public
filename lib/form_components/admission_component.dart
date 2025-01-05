import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/const.dart';
import '../form_widgets/event_value_list.dart';
import '../form_widgets/file_picker_list.dart';


class ProgramForm extends StatefulWidget {
  final Session session;

  ProgramForm({Key? key, required this.session}) : super(key: key);

  @override
  _ProgramFormState createState() => _ProgramFormState();
}

class _ProgramFormState extends State<ProgramForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _programName = [
    'Program 1',
    'Program 2',
    'Johnson & Johnson',
    'AstraZeneca',
  ];
  Map<String, dynamic> values = {
    "programs": [],
    "files": [],
    "notes": "",
  };
  List<dynamic> programs = [];

  @override
  void initState() {
    super.initState();
    values = widget.session.encounter?.encounterData[COMPONENT_NAMES.PROGRAM_ADMISSION] ?? values;
    programs = List.from(values['programs']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Admission')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Programs'),
                      EventTextList(eventTitle: 'Program Name', textTitle: 'Duration', events: _programName,  entries: programs,),
                      SizedBox(height: 10),
                      Text('Attach File'),
                      FileListWidget(values: values),
                      SizedBox(height: 10),
                      Text('Notes'),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        initialValue: values["notes"],
                        maxLines: null,
                        minLines: 4,
                        onChanged: (value) {
                          values["notes"] = value;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.save();
                            values["programs"] = programs;
                            widget.session.encounter?.addComponentData(COMPONENT_NAMES.PROGRAM_ADMISSION, values);
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
