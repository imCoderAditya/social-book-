import 'package:image_picker/image_picker.dart' show XFile;

enum PickedMediaType { image, video }

class PickedMediaResult {
  final XFile file;
  final PickedMediaType type;

  PickedMediaResult({
    required this.file,
    required this.type,
  });

  bool get isImage => type == PickedMediaType.image;
  bool get isVideo => type == PickedMediaType.video;
}
