// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUtil {
  Future<PlatformFile?> pick(BuildContext context, {FileType? type}) async {
    List<PlatformFile>? paths;
    paths = (await FilePicker.platform.pickFiles(
      type: type ?? FileType.any,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => null,
    ))
        ?.files;

    if ((paths ?? []).isNotEmpty) {
      return paths!.first;
    } else {
      return null;
    }
  }

  Future<List<PlatformFile>?> pickMulti(BuildContext context) async {
    List<PlatformFile>? paths;
    paths = (await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      onFileLoading: (FilePickerStatus status) => null,
    ))
        ?.files;

    if ((paths ?? []).isNotEmpty) {
      return paths!;
    } else {
      return null;
    }
  }
}
