import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return File(image.path);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
