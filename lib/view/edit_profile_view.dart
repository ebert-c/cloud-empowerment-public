import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/session_model.dart';

class EditProfileView extends StatefulWidget {
  final Session session;

  EditProfileView({required this.session});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    final _imageFile = this._imageFile;
    if (_imageFile != null) {
      List<int> bytes = await _imageFile.readAsBytes();
      widget.session.currentUser.photo = base64Encode(bytes);
      await widget.session.currentUser.updateUser(widget.session);
    }
    Navigator.pop(context, _imageFile != null);
  }

  @override
  Widget build(BuildContext context) {
    Object currentImage = widget.session.currentUser.photo != "" ? MemoryImage(
        base64.decode(
            widget.session.currentUser.photo)) : AssetImage("assets/anon_user.png");
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null ? currentImage as ImageProvider<Object> : FileImage(_imageFile!)
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Take Picture'),
                onPressed: _takePicture,
              ),
              SizedBox(
                width: 16.0,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Pick Image'),
                onPressed: _pickImage,
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            child: Text('Save Changes'),
            onPressed: _saveChanges,
          ),
        ],
      ),
    );
  }
}
