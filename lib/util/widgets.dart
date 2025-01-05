import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import 'const.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

ImageProvider<Object> profilePicture(Session session) {
  if (session.currentUser.photo.isEmpty) {
    return AssetImage("assets/anon_user.png");
  } else {
    return MemoryImage(base64Decode(session.currentUser.photo));
  }
}

InkWell tile(context, icon, name, color, route, session) {
  return InkWell(
    onTap: () => Navigator.pushNamed(context, route, arguments: session),
    child: Container(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: 80,
            color: color,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

InkWell tileWithReload(context, icon, name, color, route, session, setState) {
  return InkWell(
    onTap: () => Navigator.pushNamed(context, route, arguments: session)
        .then((_) => setState(() {})),
    child: Container(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: 80,
            color: color,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

class SearchableList extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  SearchableList({required this.items});

  @override
  _SearchableListState createState() => _SearchableListState();
}

class _SearchableListState extends State<SearchableList> {
  TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _onTextChanged(String value) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search forms',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
            ),
            onChanged: _onTextChanged,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item['title'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  subtitle: Text(item['subtitle'],
                      style: TextStyle(color: COLORS.RED)),
                  onTap: () {
                    item['onTap']();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PatientList extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  PatientList({required this.items});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _onTextChanged(String value) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search patients',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
            ),
            onChanged: _onTextChanged,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _filteredItems[index];
                return ListTile(
                    title: Text(item['title'], style: TextStyle(fontSize: 18)),
                    onTap: () {
                      item['onTap'](item['subtitle']);
                    },
                    leading: CircleAvatar(
                        backgroundImage: item['icon'] == ""
                            ? AssetImage("assets/anon_user.png")
                            : DecorationImage(
                                    image: MemoryImage(
                                        base64.decode(item['icon'] ?? "")),
                                    fit: BoxFit.cover)
                                .image));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AvatarPicker extends StatefulWidget {
  final Map<String, dynamic> values;
  final MemoryImage? initialData;

  AvatarPicker({Key? key, required this.values, this.initialData})
      : super(key: key);

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _imageFile;

  get values => widget.values;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      List<int> bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = File(pickedFile.path);
        values['photo'] = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? image;
    print(widget.initialData);
    if (widget.initialData != null) {
      image = widget.initialData;
    } else {
      image = _imageFile != null
          ? FileImage(_imageFile!)
          : AssetImage('assets/anon_user.png') as ImageProvider;
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 50.0,
          backgroundImage: image,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              child: const Text('Take Photo'),
            ),
          ],
        ),
      ],
    );
  }
}

OverlayEntry createOverlayEntry() {
  return OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), // Darkens the screen with a semi-transparent black background
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 25,
          left: MediaQuery.of(context).size.width / 2 - 25,
          child: CircularProgressIndicator(),
        )
      ],
    ),
  );
}