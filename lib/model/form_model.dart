import 'dart:convert';
import 'dart:core';

class LocalForm {
  List<String> components;
  String name;
  String description;
  String id;

  LocalForm({
    required this.components,
    required this.name,
    required this.description,
    required this.id
  });

  factory LocalForm.fromJson(Map<String, dynamic> json) {
    String name = json["name"];
    String description = json["description"];
    String id = json["formId"];
    List<dynamic> decodedComponents = List<String>.from(jsonDecode(json["components"]));
    List<String> components = decodedComponents.map((item) => item.toString()).toList();
    return LocalForm(components: components, name: name, description: description, id: id);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'formId': this.id,
      'name': this.name,
      'description': this.description,
      'components': jsonEncode(this.components)
    };
    return json;
  }
}