import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/patient_model.dart';
import '../model/session_model.dart';
import '../util/const.dart';
import '../util/util.dart';
import '../util/widgets.dart';

class AddPatientView extends StatefulWidget {
  final Session session;

  AddPatientView({Key? key, required this.session}) : super(key: key);

  @override
  _AddPatientViewState createState() {
    return _AddPatientViewState();
  }
}

class _AddPatientViewState extends State<AddPatientView> {
  final _formKey = GlobalKey<FormState>();


  Session get session => widget.session;
  final Map<String, dynamic> values = {
    "firstName": "",
    "lastName": "",
    "dateOfBirth": null,
    "age": null,
    "bloodType": BLOOD_TYPES[0],
    "gender": GENDERS[0],
    "insuranceNumber": "",
    "insuranceProvider": "",
    "mailingAddress": "",
    "contactAddress": "",
    "phoneNumber": "",
    "emailAddress": "",
    "nextOfKinFirstName": "",
    "nextOfKinLastName": "",
    "nextOfKinContactAddress": "",
    "nextOfKinRelationship": "",
    "nextOfKinPhoneNumber": "",
    "nextOfKinEmail": "",
    "photo": null
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Patient Registration'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Patient", style: TextStyle(fontSize: 20)),
                          Divider(
                            thickness: 4,
                          ),
                          AvatarPicker(values: values),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              if (value.length > 25) {
                                return "Max character limit of 25 exceeded";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["firstName"] = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["lastName"] = value!;
                            },
                          ),
                          TextFormField(
                            readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter date of birth';
                                }
                                return null;
                              },
                            controller: TextEditingController(
                              text: values["dateOfBirth"] == null
                                  ? ''
                                  : '${values["dateOfBirth"]!.day}/${values["dateOfBirth"]!.month.toString().padLeft(2, "0")}/${values["dateOfBirth"]!.year}',
                            ),
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate:
                                    values["dateOfBirth"] ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  values["dateOfBirth"] = selectedDate;
                                  values["age"] =
                                      Util.calculateAge(selectedDate);
                                });
                              }
                            },
                            onSaved: (value) {
                              // nothing to do here since we're using a controller
                            },
                          ),
                          TextFormField(
                            controller: TextEditingController(
                              text: values["age"] == null
                                  ? ''
                                  : '${values["age"]}',
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Age',
                            ),
                            onSaved: (value) {
                              // nothing to do here since we're using a controller
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Blood Type',
                            ),
                            value: values["bloodType"],
                            items: BLOOD_TYPES.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                values["bloodType"] =
                                    value != null ? value as String : "";
                              });
                            },
                            onSaved: (value) {
                              values["bloodType"] = (value as String?)!;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                            ),
                            value: values["gender"],
                            items: GENDERS.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                values["gender"] =
                                    value != null ? value as String : "";
                              });
                            },
                            onSaved: (value) {
                              values["gender"] = (value as String?)!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Insurance Number',
                            ),
                            onSaved: (value) {
                              values["insuranceNumber"] = value!;
                            },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter insurance number';
                                }
                                return null;
                              },
                            inputFormatters: NUMERICAL_INPUT
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Insurance Provider',
                            ),
                            onSaved: (value) {
                              values["insuranceProvider"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter insurance provider';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Mailing Address',
                            ),
                            onSaved: (value) {
                              values["mailingAddress"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mailing address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contact Address',
                            ),
                            onSaved: (value) {
                              values["contactAddress"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                            ),
                            inputFormatters: NUMERICAL_INPUT,
                            onSaved: (value) {
                              values["phoneNumber"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'E-mail Address',
                            ),
                            onSaved: (value) {
                              values["emailAddress"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Text("Next of Kin",
                                  style: TextStyle(fontSize: 20))),
                          Divider(
                            thickness: 4,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["nextOfKinFirstName"] = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["nextOfKinLastName"] = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contact Address',
                            ),
                            onSaved: (value) {
                              values["nextOfKinContactAddress"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                            ),
                            inputFormatters: NUMERICAL_INPUT,
                            onSaved: (value) {
                              values["nextOfKinPhoneNumber"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'E-mail Address',
                            ),
                            onSaved: (value) {
                              values["nextOfKinEmail"] = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Relationship',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter relationship';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              values["nextOfKinRelationship"] = value!;
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(builder: (context) => AlertDialog(
                                  title: Text("Patient Creation Confirmation"),
                                  content: Text("Confirm patient creation?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context)
                                    ),
                                    TextButton(
                                      child: Text("Confirm"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                        save();
                                        },
                                    )
                                  ]
                                ), context: context);
                              },
                              child: const Text('Submit'))
                        ])))));
  }

  Future<void> save() async {
    String patientId = Uuid().v4();
    String doctorId = session.currentUser.identity_id;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Patient newPatient = new Patient(
        firstName: values["firstName"],
        lastName: values["lastName"],
        birthday: values["dateOfBirth"].toString(),
        bloodGroup: values["bloodType"],
        gender: values["gender"],
        insurance_number: values["insuranceNumber"],
        insurance_provider:
        values["insuranceProvider"],
        patient_identity: patientId,
        mailing_address: values["mailingAddress"],
        contact_address: values["contactAddress"],
        phone_number: values["phoneNumber"],
        email_address: values["emailAddress"],
        nok_name:
        '${values["nextOfKinFirstName"]} ${values["nextOfKinLastName"]}',
        nokin_address:
        values["nextOfKinContactAddress"],
        nok_relationship:
        values["nextOfKinRelationship"],
        nok_phone: values["nextOfKinPhoneNumber"],
        nok_email: values["nextOfKinEmail"],
        doctor_id: doctorId,
        photo: values["photo"]
      );
      await session.currentUser.addPatient(newPatient, session);
      Navigator.pop(context);
    }
  }
}
