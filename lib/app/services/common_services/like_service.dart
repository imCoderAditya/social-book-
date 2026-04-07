import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class LikeService extends GetxService {
  static LikeService get to => Get.find();

  Future<bool> like({
    required int contentId,
    required bool isCurrentlyLiked,
    String contentType = "Post",
  }) async {
    try {
      final profileId = LocalStorageService.getProfileId();

      // Agar pehle se liked hai toh ab "unLike" bhejenge, warna "Like"
      final reaction = isCurrentlyLiked ? "NoReaction" : "Like";

      final response = await BaseClient.post(
        api: EndPoint.like, // Apna asli endpoint yahan dalein
        data: {
          "ContentType": contentType,
          "ContentID": contentId,
          "ProfileID": profileId,
          "ReactionType": reaction,
        },
      ); 

      if (response != null && response.statusCode == 201) {
        LoggerUtils.debug("$contentType $reaction successful");
        if (response.data["success"] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      LoggerUtils.error("Error in LikeService: $e");
      return false;
    }
  }
}
