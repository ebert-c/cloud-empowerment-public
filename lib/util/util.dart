import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

enum ImageSourceType {gallery, camera}

class Util {
  static Future<String> imageSubmit(BuildContext context, var type) async {
    var imagePicker = new ImagePicker();
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);

    if (image != null) {
      return base64Encode(await image.readAsBytes());
    } else {
      return "";
    }
  }

  static int calculateAge(DateTime dateOfBirth) {
    // Calculate the difference between the current date and the date of birth
    Duration difference = DateTime.now().difference(dateOfBirth);

    // Convert the difference into years
    int age = (difference.inDays / 365).floor();

    return age;
  }
}

class AppConnectivity {
  AppConnectivity();

  static final Connectivity _connectivity = Connectivity();

  static Future<ConnectivityResult> getConnectionType() async {
    try {
      return await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return ConnectivityResult.none;
    }
  }

  static Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }


  static Future<bool> isConnected() async {
    if (await getConnectionType() == ConnectivityResult.none) {
      return false;
    } else if (!await isConnectedToInternet()) {
      return false;
    } else {
      return true;
    }
  }
}

class Representation extends Comparable {
  String label;
  String id;
  String icon;

  Representation({
    required this.label,
    required this.id,
    required this.icon
  });

  @override
  int compareTo(other) {
    return this.label.compareTo(other.label);
  }


}

class Entry {
  String eventVal;
  String valueVal;
  String event;
  String value;

  Entry({
    required this.eventVal,
    required this.valueVal,
    required this.event,
    required this.value
  });

  bool operator ==(o) =>
      o is Entry &&
          o.eventVal == this.eventVal &&
          o.valueVal == this.valueVal;

  Map<String, dynamic> toJson() {
    return {event: eventVal, value: valueVal};
  }
}

enum FileType {
  img,
  gif,
  pdf,
  unknown
}

FileType determineFileTypeFromBase64(String base64) {
  // decode the base64 string into bytes
  List<int> bytes = base64Decode(base64);

  // check for JPEG file signature
  if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return FileType.img;
  }

  // check for PNG file signature
  if (bytes.length > 7 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47 && bytes[4] == 0x0D && bytes[5] == 0x0A && bytes[6] == 0x1A && bytes[7] == 0x0A) {
    return FileType.img;
  }

  // check for GIF file signature
  if (bytes.length > 2 && bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
    return FileType.gif;
  }

  // check for PDF file signature
  if (bytes.length > 4 && bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46) {
    return FileType.pdf;
  }

  // unknown file type
  return FileType.unknown;
}

Future<String> getDocumentsPath() async {
  Directory enclosingDir = await getApplicationDocumentsDirectory();
  return '${enclosingDir.path}/CloudEmpowerment';
}

String getExtensionFromBytes(List<int> bytes) {
  final List<String> allowedFileTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'mp3',
    'wav',
    'mp4',
    'avi',
    'mov',
    'wmv',
  ];
  final int byteCount = bytes.length;
  final int maxBytesToCheck = 16;
  int bytesToCheck = byteCount < maxBytesToCheck ? byteCount : maxBytesToCheck;
  String fileType = '';
  for (int i = 0; i < bytesToCheck; i++) {
    int byte = bytes[i];
    if (byte == 0xFF) {
      fileType = 'jpg';
    } else if (byte == 0x89) {
      fileType = 'png';
    } else if (byte == 0x47) {
      fileType = 'gif';
    } else if (byte == 0x42) {
      fileType = 'bmp';
    } else if (byte == 0x25) {
      fileType = 'pdf';
    } else if (byte == 0xD0) {
      fileType = 'doc';
    } else if (byte == 0xE0) {
      fileType = 'xls';
    } else if (byte == 0x50 || byte == 0x7B || byte == 0xEC) {
      fileType = 'ppt';
    } else if (byte == 0x49 || byte == 0x4D) {
      fileType = 'mp3';
    } else if (byte == 0x52 || byte == 0x61) {
      fileType = 'wav';
    } else if (byte == 0x66) {
      fileType = 'mp4';
    } else if (byte == 0x52 || byte == 0x61) {
      fileType = 'avi';
    } else if (byte == 0x6D) {
      fileType = 'mov';
    } else if (byte == 0x30) {
      fileType = 'wmv';
    }
    if (fileType.isNotEmpty && allowedFileTypes.contains(fileType)) {
      return fileType;
    }
  }
  return '';
}
