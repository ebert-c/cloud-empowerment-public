import 'package:cloudempowerment/util/const.dart';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/local_database.dart';
import '../util/util.dart';
import '../util/widgets.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({required this.session});

  final Session session;

  @override
  _PatientListViewState createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  get currentUser => widget.session.currentUser;
  DatabaseHelper get databaseHelper => widget.session.databaseHelper;
  Session get session => widget.session;
  List<Representation>? patients = null;

  Future<void> _getPatients() async {
    List<Representation> list = await databaseHelper.getPatientNamesAndPhotos();
    list.sort();
    setState(() {
      patients = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(
                  ROUTES.ADD_PATIENT, arguments: widget.session);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              "Patient List",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: patients != null
                  ? PatientList(
                      items: patients!.map((p) {
                      return {'title': p.label, 'icon': p.icon, 'onTap': openPatient, 'subtitle': p.id};
                    }).toList())
                  : Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  void openPatient(String patientId) {
    session.setArgs({'patientId': patientId});
    Navigator.of(context)
        .pushNamed(
        ROUTES.PATIENT_INFO, arguments: widget.session);
  }
}


