
import 'package:insta_assets_picker/insta_assets_picker.dart';

class InstaMediaResult {
  final InstaAssetsExportDetails croppedFiles; // Final cropped images
  final List<AssetEntity> originalAssets; // Original metadata (for video/duration/etc)

  InstaMediaResult({required this.croppedFiles, required this.originalAssets});
}