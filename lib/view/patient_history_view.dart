import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/patient_model.dart';
import '../model/session_model.dart';
import '../util/const.dart';

class PatientHistoryView extends StatefulWidget {
  const PatientHistoryView({required this.session});

  final Session session;

  @override
  _PatientHistoryViewState createState() => _PatientHistoryViewState();
}

class _PatientHistoryViewState extends State<PatientHistoryView> {
  String _selectedSortOption = "Date (Newest to Oldest)";
  Session get session => widget.session;
  Patient get patient => session.getArg('patient');

  List<Map<String, String>> history = [];



  Future<void> _getHistory() async {
    history = await session.databaseHelper.getHistory(patient.patient_identity);
    sortPatientHistory();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient History"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
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
                              backgroundImage: patient.photo != null && patient.photo != "" ? DecorationImage(
                                  image: MemoryImage(base64.decode(patient.photo ?? "")),
                                  fit: BoxFit.cover
                              ).image
                                  : AssetImage("assets/anon_user.png"),
                              radius: 30),
                          SizedBox(width: 20),
                          Text('${patient.firstName} ${patient.lastName}', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    )))
          ]),
          SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("VISIT HISTORY", style: TextStyle(fontSize: 24)),
              DropdownButton(
                value: _selectedSortOption,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSortOption = newValue as String;
                    sortPatientHistory();
                  });
                },
                items: [
                  DropdownMenuItem(
                      value: "Date (Newest to Oldest)",
                      child: Text("Date (Newest to Oldest)")),
                  DropdownMenuItem(
                      value: "Date (Oldest to Newest)",
                      child: Text("Date (Oldest to Newest)")),
                  DropdownMenuItem(
                      value: "Provider (A-Z)", child: Text("Provider (A-Z)")),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    session.addArg('encounterId', history[index]['encounterId']);
                    Navigator.of(context).pushNamed(ROUTES.VISIT, arguments: session);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Provider: ${history[index]["providerName"]!}',
                            style: TextStyle(fontSize: 16)),
                        Text(history[index]['date']!,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void sortPatientHistory() {
    if (_selectedSortOption == "Date (Newest to Oldest)") {
      history.sort((a, b) => int.parse(b["encounterId"]!).compareTo(int.parse(a["encounterId"]!)));
    } else if (_selectedSortOption == "Date (Oldest to Newest)") {
      history.sort((a, b) => int.parse(a["encounterId"]!).compareTo(int.parse(b["encounterId"]!)));
    } else if (_selectedSortOption == "Provider (A-Z)") {
      history
          .sort((a, b) {
            int comparison = a['providerName']!.compareTo(b['providerName']!);
            if(comparison == 0) {
              return int.parse(a["encounterId"]!).compareTo(int.parse(b["encounterId"]!));
            }
            return comparison;
      });
    }
  }
}
