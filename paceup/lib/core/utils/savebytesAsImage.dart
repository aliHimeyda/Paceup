import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<File> saveBytesToFile(Uint8List bytes, String fileName) async {
  final dir = await getApplicationDocumentsDirectory(); // current folder path
  final file = File('${dir.path}/$fileName.jpg'); //for example : image1.jpg
  return file.writeAsBytes(bytes, flush: true);
}
