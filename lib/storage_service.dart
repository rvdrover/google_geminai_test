import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  final String directoryName;

  StorageService({required this.directoryName});

  storeFile(
      {required String fileName,
      required String fileExtension,
      required Uint8List fileData,
      Function(XFile)? onComplete,
      Function(String)? onError}) async {
    Directory? directory;
    try {
      if (!Platform.isAndroid) {
        directory = await getApplicationDocumentsDirectory();
        directory = Directory('${directory.path}/$directoryName');
      } else {
        directory = await getExternalStorageDirectory();
      }

      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        final file = File('${directory.path}/$fileName.$fileExtension');
        await file.writeAsBytes(fileData);
        if (onComplete != null) onComplete(XFile(file.path));
      }
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
  }
}
