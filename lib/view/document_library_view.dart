import 'dart:io';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import '../util/util.dart';

class DocumentsLibraryView extends StatefulWidget {
  final Session session;

  DocumentsLibraryView({required this.session});

  @override
  _DocumentsLibraryViewState createState() => _DocumentsLibraryViewState();
}

class _DocumentsLibraryViewState extends State<DocumentsLibraryView> {
  List<File> _files = [];
  get session => widget.session;
  String directoryPath = "";

  Future<void> _loadFiles() async {
    directoryPath = await getDocumentsPath();
    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> entities = directory.listSync();
    List<File> files = entities.whereType<File>().toList();
    setState(() {
      _files = files;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document Library"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          File file = _files[index];
          return ListTile(
            title: Text(file.path),
          );
        },
      ),
    );
  }
}


