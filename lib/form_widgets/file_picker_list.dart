import 'dart:convert';
import 'dart:io';
import 'package:cloudempowerment/util/util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class FileListWidget extends StatefulWidget {
  final List<dynamic> files = [];
  List<String> fileValues = [];
  Map<String, dynamic> values;

  FileListWidget({required this.values});

  @override
  _FileListWidgetState createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  get _files => widget.files;

  get fileValues => widget.fileValues;

  get values => widget.values;

  Future<void> _addFileValues(File file) async {
    List<int> bytes = await file.readAsBytes();
    fileValues.add(base64Encode(bytes));
    values['files'] = fileValues;
  }

  void _removeFileValues(int index) async {
    values['files'].removeAt(index);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      String type = pickedFile.path
          .split('.')
          .last;
      if (type == 'png' || type == 'jpg') {
        File file = File(pickedFile.path);
        Image img = await fileToImage(file);
        setState(() {
          _files.add(img);
          _addFileValues(file);
        });
        return;
      }
      setState(() {
        File file = File(pickedFile.path);
        _files.add(file);
        _addFileValues(file);
      });
    }
  }

  Future<Image> fileToImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = Image.memory(bytes);
    return image;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File pickedFile = File(result.files.single.path!);
      setState(() {
        _files.add(pickedFile);
        _addFileValues(pickedFile);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
      _removeFileValues(index);
    });
  }

  Future<void> _addFiles(List<File> files) async {
    for (var f in files) {
      String type = f.path.split('.').last;
      if (type == "jpg" || type == "png" || type == "jpeg") {
        Image i = await fileToImage(f);
        setState(() {
          _files.add(i);
        });
      } else {
        setState(() {
          _files.add(f);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final tempDir = Directory.systemTemp;
    List<File> tempList = [];
    for (var data in values['files']) {
      List<int> bytes = base64.decode(data);
      String type = getExtensionFromBytes(bytes);
      final filenameSafe = Uuid().v4().replaceAll('-', '');
      File f = File(tempDir.path +'/'+ filenameSafe + '.' + type);
      f.writeAsBytesSync(bytes);
      tempList.add(f);
    }
  _addFiles(tempList);
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                Image? image;
                if (file is Image) {
                  image = file;
                }
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.file_copy),
                    onPressed: () {

                    },),
                  title: image != null
                      ? SizedBox(
                      height: 200,
                      width: 150,
                      child: image)
                      : Text(file.path
                      .split('/')
                      .last),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeFile(index),
                  ),
                );
              },
            )),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => _pickFile(),
            child: Text('Add File'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Text('Take Picture'),
          ),
        ],
      ),
    ],
  );
}}
