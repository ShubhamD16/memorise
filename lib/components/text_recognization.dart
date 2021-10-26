import 'dart:io';

//import 'package:google_ml_vision/google_ml_vision.dart';

import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getImageFile() async {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
  // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    return File(photo.path);
  }
  return null;
}

/*
Future<String?>? getTextFromImage() async {
  File? imagefile = await getImageFile();

  if (imagefile != null) {
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imagefile);
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String? text = visionText.text;
    textRecognizer.close();
    if (text != null) {
      if (text.isNotEmpty) {
        return text;
      }
    }
  }

  return null;
}
*/

/////////////////////////////////////////////

Future<File?> getPhotoFile() async {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    return File(photo.path);
  }
  return null;
}

/*
Future<String?>? getTextFromPhoto() async {
  File? imagefile = await getPhotoFile();

  if (imagefile != null) {
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imagefile);
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String? text = visionText.text;
    textRecognizer.close();
    if (text != null) {
      if (text.isNotEmpty) {
        return text;
      }
    }
  }

  return null;
}

*/

Future<String?>? getTextFromImage() async {
  File? imagefile = await getImageFile();

  if (imagefile != null) {
    String? text = await FlutterTesseractOcr.extractText(imagefile.path);

    if (text != null) {
      if (text.isNotEmpty) {
        return text;
      }
    }
  }

  return null;
}

Future<String?>? getTextFromPhoto() async {
  File? imagefile = await getPhotoFile();

  if (imagefile != null) {
    String? text = await FlutterTesseractOcr.extractText(imagefile.path);
    if (text != null) {
      if (text.isNotEmpty) {
        return text;
      }
    }
  }

  return null;
}
