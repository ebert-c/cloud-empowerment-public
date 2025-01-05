import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class EventValueList extends StatefulWidget {
  List<String> eventList;
  List<String> valueList;
  String event;
  String value;
  List<Entry> entries;

  EventValueList(
      {required this.event,
      required this.eventList,
      required this.value,
      required this.valueList,
      required this.entries});

  @override
  _EventValueListState createState() => _EventValueListState();
}

class _EventValueListState extends State<EventValueList> {

  List<String> get eventList => widget.eventList;
  List<String> get valueList => widget.valueList;
  String get event => widget.event;
  String get value => widget.value;
  List<Entry> get entries => widget.entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 0.0),
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: eventList[0],
                                onChanged: (value) {
                                  setState(() {
                                    entries[index].eventVal =
                                    value!;
                                  });
                                },
                                items: eventList
                                    .map<DropdownMenuItem<String>>(
                                        (String option) {
                                      return DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: event,
                                    isDense: true),
                              ),
                              SizedBox(height:10),
                              DropdownButtonFormField<String>(
                                value: valueList[0],
                                onChanged: (value) {
                                  setState(() {
                                    entries[index].valueVal = value!;
                                  });
                                },
                                items: valueList
                                    .map<DropdownMenuItem<String>>(
                                        (String option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ))
                                    .toList(),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: value,
                                    isDense: true),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    entries.removeAt(index);
                                  });
                                },
                              ),
                              Divider(thickness: 2,)
                            ],
                          ));
                    },
                  ))),
        SizedBox(height: 5.0),
        ElevatedButton(
          child: Text('Add Entry'),
          onPressed: () {
            setState(() {
              entries.add(Entry(
                eventVal: eventList.first,
                valueVal: valueList.first,
                event: event,
                value: value
              ));
            });
          },
        ),
      ],
    );
  }
}

class EventTextList extends StatefulWidget {
  String eventTitle;
  String textTitle;
  List<String> events;
  List<dynamic> entries;

  EventTextList(
      {required this.eventTitle,
        required this.textTitle,
        required this.events,
        required this.entries,});

  @override
  _EventTextListState createState() => _EventTextListState();
}

class _EventTextListState extends State<EventTextList> {

  String get textTitle => widget.textTitle;
  String get eventTitle => widget.eventTitle;
  List<String> get events => widget.events;
  List<dynamic> get entries => widget.entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 0.0),
                        child: Column(
                          children: [
                            SizedBox(height: 4),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: eventTitle,
                              ),
                              initialValue: entries[index].eventVal ?? "",
                              onChanged: (value) {
                                entries[index].eventVal = value;
                              },
                            ),
                           TextFormField(
                                 decoration: InputDecoration(
                                   labelText: textTitle,
                                 ),
                                 initialValue: entries[index].valueVal ?? "",
                                 onChanged: (value) {
                                   entries[index].valueVal = value;
                                 },
                               ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  entries.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ));
                  },
                ))),
        SizedBox(height: 5.0),
        ElevatedButton(
          child: Text('Add Entry'),
          onPressed: () {
            setState(() {
              entries.add(Entry(
                eventVal: events.first,
                valueVal: "",
                event: eventTitle,
                value: textTitle
              ));
            });
          },
        ),
      ],
    );
  }
}

class EventList extends StatefulWidget {
  List<String> entries;
  List<String> options;

  EventList(
      {required this.entries,
      required this.options});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  List<String> get entries => widget.entries;
  List<String> get options => widget.options;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                items: options,
                                onChanged: (val) {
                                  entries[index] = val != null ? val : "";
                                },
                                selectedItem: entries[index],
                                showSearchBox: true,
                                dropdownSearchDecoration:
                                InputDecoration(border: OutlineInputBorder()),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  entries.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ));
                  },
                ))),
        SizedBox(height: 5.0),
        ElevatedButton(
          child: Text('Add Entry'),
          onPressed: () {
            setState(() {
              entries.add(options.first);
            });
          },
        ),
      ],
    );
  }
}

class CodeList extends StatefulWidget {
  List<Map<String, dynamic>> entries;
  List<Map<String, dynamic>> options;

  CodeList(
      {required this.entries,
        required this.options});

  @override
  _CodeListState createState() => _CodeListState();
}

class _CodeListState extends State<CodeList> {

  List<Map<String, dynamic>> get entries => widget.entries;
  List<Map<String, dynamic>> get options => widget.options;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<Map<String, dynamic>>(
                                mode: Mode.MENU,
                                items: options,
                                itemAsString: (item) => item!['display'],
                                onChanged: (val) {
                                  entries[index] = val != null ? val : {};
                                },
                                selectedItem: entries[index],
                                showSearchBox: true,
                                dropdownSearchDecoration:
                                InputDecoration(border: OutlineInputBorder()),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  entries.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ));
                  },
                ))),
        SizedBox(height: 5.0),
        ElevatedButton(
          child: Text('Add Entry'),
          onPressed: () {
            setState(() {
              entries.add(options.first);
            });
          },
        ),
      ],
    );
  }
}

class PrescriptionList extends StatefulWidget {
  List<Map<String, dynamic>> entries;
  List<Map<String, dynamic>> options;

  PrescriptionList(
      {required this.entries,
        required this.options});

  @override
  _PrescriptionListState createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {

  List<Map<String, dynamic>> get entries => widget.entries;
  List<Map<String, dynamic>> get options => widget.options;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 0.0),
                        child: Column(
                          children: [
                            Text("Drug"),
                            DropdownSearch<Map<String, dynamic>>(
                                mode: Mode.MENU,
                                items: options,
                                itemAsString: (item) => item!['display'],
                                onChanged: (val) {
                                  entries[index] = val != null ? val : {};
                                },
                                selectedItem: entries[index],
                                showSearchBox: true,
                                dropdownSearchDecoration:
                                InputDecoration(border: OutlineInputBorder()),
                              ),
                            SizedBox(height:10),
                            Text("Dosage"),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder()
                              ),
                              onChanged: (value) {
                                entries[index]['dosage'] = value;
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  entries.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ));
                  },
                ))),
        SizedBox(height: 5.0),
        ElevatedButton(
          child: Text('Add Entry'),
          onPressed: () {
            setState(() {
              entries.add(options.first);
            });
          },
        ),
      ],
    );
  }
}

