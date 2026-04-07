
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/post/my_post_model.dart';
import 'package:social_book/app/data/models/story/story_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

/// Represents a unified story item used in the viewer (works for both
/// MyPostData and StoryData so we don't duplicate viewer logic).
class UnifiedStory {
  final String? mediaUrl;
  final String? mediaType; // 'image' | 'video' | 'text'
  final String? content;
  final String? displayName;
  final String? profilePicture;
  final String? createdDate;
  final int? userId;
  final int? postId;
  final bool isMyStory;

  const UnifiedStory({
    this.mediaUrl,
    this.mediaType,
    this.content,
    this.displayName,
    this.profilePicture,
    this.createdDate,
    this.userId,
    this.postId,
    this.isMyStory = false,
  });

  bool get isVideo => mediaType == 'video';
  bool get isImage => mediaType == 'image';
  bool get isText => mediaType == 'text' || (mediaUrl == null && content != null);
}

/// Groups all stories belonging to one user/profile for the horizontal tray.
class StoryGroup {
  final int userId;
  final String? displayName;
  final String? profilePicture;
  final List<UnifiedStory> stories;
  final bool isMyGroup;

  const StoryGroup({
    required this.userId,
    this.displayName,
    this.profilePicture,
    required this.stories,
    this.isMyGroup = false,
  });

  UnifiedStory get firstStory => stories.first;
}

class StoryController extends GetxController {
  // ─── Raw API models ───────────────────────────────────────────────────────
  Rxn<StoryModel> storyModel = Rxn<StoryModel>();
  Rxn<MyPostModel> myStoryModel = Rxn<MyPostModel>();

  // ─── UI state ─────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // ─── Viewer state ─────────────────────────────────────────────────────────
  /// Index into [storyGroups] (which group is currently open)
  final currentGroupIndex = 0.obs;

  /// Index into the current group's stories list
  final currentStoryIndex = 0.obs;

  /// 0.0 → 1.0 progress for the active progress bar segment
  final storyProgress = 0.0.obs;

  final isMuted = false.obs;
  final currentStoryViewCount = 0.obs;

  // ─── Viewed tracking ──────────────────────────────────────────────────────
  final viewedStories = <int>{}.obs; // stores postId values

  // ─── Timer ────────────────────────────────────────────────────────────────
  Timer? _timer;

  /// Default duration per IMAGE / TEXT story (seconds).
  /// Videos override this with their own duration.
  final storyDuration = 7;

  // ─── Processed data ───────────────────────────────────────────────────────
  /// Ordered list of story groups shown in the tray.
  /// Index 0 is always "My Story" (even if empty – shows Add button).
  RxList<StoryGroup> storyGroups = <StoryGroup>[].obs;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchMyStory();
    fetchStory();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DATA FETCHING
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> fetchMyStory() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final userId = LocalStorageService.getUserId();
      final profileId = LocalStorageService.getProfileId();

      final res = await BaseClient.get(
        api: "${EndPoint.getMyPost}?userId=$userId&profileId=$profileId"
            "&search=&PostType=Story&pageNumber=1&pageSize=10000",
      );

      if (res != null && res.statusCode == 200) {
        myStoryModel.value = myPostModelFromJson(json.encode(res.data));
        log("myStoryModel fetched: ${myStoryModel.value?.myPostData?.length} items");
        _buildStoryGroups();
      } else {
        hasError.value = true;
        errorMessage.value = "Failed to load my stories";
        LoggerUtils.error("fetchMyStory failed: ${res?.data}");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error loading my stories";
      LoggerUtils.error("fetchMyStory error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStory() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final userId = LocalStorageService.getUserId();
      final profileId = LocalStorageService.getProfileId();

      final res = await BaseClient.get(
        api: "${EndPoint.searchStory}?userId=$userId&profileId=$profileId"
            "&search=&PostType=Story&pageNumber=1&pageSize=10000",
      );

      if (res != null && res.statusCode == 200) {
        storyModel.value = storyModelFromJson(json.encode(res.data));
        _buildStoryGroups();
      } else {
        hasError.value = true;
        errorMessage.value = "Failed to load stories";
        LoggerUtils.error("fetchStory failed: ${res?.data}");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error loading stories";
      LoggerUtils.error("fetchStory error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DATA PROCESSING
  // ══════════════════════════════════════════════════════════════════════════

  void _buildStoryGroups() {
    final myUserId = LocalStorageService.getUserId();
    final List<StoryGroup> groups = [];

    // ── 1. MY STORY GROUP (always first) ────────────────────────────────────
    final myRawStories = myStoryModel.value?.myPostData ?? [];
    final List<UnifiedStory> myUnified = myRawStories.map((s) {
      final type = _resolveTypeFromMyPost(s);
      final url = (s.mediaUrl?.isNotEmpty == true) ? s.mediaUrl!.first : null;
      return UnifiedStory(
        mediaUrl: url,
        mediaType: type,
        content: s.content,
        displayName: s.displayName ?? 'You',
        profilePicture: s.profilePicture,
        createdDate: s.createdAt,
        userId: s.userId ?? myUserId,
        postId: s.postId,
        isMyStory: true,
      );
    }).toList();

    // We always add a MyStory group (even empty → shows "Add Story" button)
    groups.add(StoryGroup(
      userId: myUserId ?? 0,
      displayName: 'Your Story',
      profilePicture: myUnified.isNotEmpty ? myUnified.first.profilePicture : null,
      stories: myUnified,
      isMyGroup: true,
    ));

    // ── 2. FRIENDS' STORY GROUPS ─────────────────────────────────────────────
    final rawFriendStories = storyModel.value?.storyData ?? [];
    final Map<int, List<StoryData>> grouped = {};

    for (final s in rawFriendStories) {
      // Skip if this is the current user's own story (already added above)
      if (s.userId == myUserId) continue;
      final uid = s.userId ?? 0;
      grouped.putIfAbsent(uid, () => []).add(s);
    }

    for (final entry in grouped.entries) {
      final uid = entry.key;
      final rawList = entry.value;

      final List<UnifiedStory> unified = rawList.map((s) {
        final type = _resolveTypeFromStoryData(s);
        final url = (s.media?.isNotEmpty == true) ? s.media!.first.url : null;
        return UnifiedStory(
          mediaUrl: url,
          mediaType: type,
          content: s.content,
          displayName: s.displayName ?? 'User',
          profilePicture: s.profilePicture,
          createdDate: s.createdAt?.toIso8601String(),
          userId: s.userId,
          postId: s.postId,
          isMyStory: false,
        );
      }).toList();

      if (unified.isEmpty) continue;

      groups.add(StoryGroup(
        userId: uid,
        displayName: rawList.first.displayName ?? 'User',
        profilePicture: rawList.first.profilePicture,
        stories: unified,
        isMyGroup: false,
      ));
    }

    storyGroups.value = groups;
    LoggerUtils.warning(
        "Built ${groups.length} story groups (1 mine + ${groups.length - 1} friends)");
  }

  /// Resolves media type string from [MyPostData].
  /// MyPostData uses plain URL list – we infer type from URL extension.
  String _resolveTypeFromMyPost(MyPostData post) {
    if (post.postType?.toLowerCase() == 'video') return 'video';

    final url = post.mediaUrl?.isNotEmpty == true ? post.mediaUrl!.first : null;
    if (url != null) {
      final lower = url.toLowerCase();
      if (lower.contains('.mp4') ||
          lower.contains('.mov') ||
          lower.contains('.avi') ||
          lower.contains('.webm')) {
        return 'video';
      }
      if (lower.contains('.jpg') ||
          lower.contains('.jpeg') ||
          lower.contains('.png') ||
          lower.contains('.gif') ||
          lower.contains('.webp')) {
        return 'image';
      }
    }

    if (post.content?.isNotEmpty == true && url == null) return 'text';
    return 'image'; // safe default
  }

  /// Resolves media type string from [StoryData].
  String _resolveTypeFromStoryData(StoryData story) {
    // Check media list first
    if (story.media?.isNotEmpty == true) {
      final mediaType = story.media!.first.type?.toString().toLowerCase() ?? '';
      if (mediaType.contains('video')) return 'video';
      if (mediaType.contains('image')) return 'image';

      // Fallback: check URL extension
      final url = story.media!.first.url?.toLowerCase() ?? '';
      if (url.contains('.mp4') || url.contains('.mov') || url.contains('.webm')) {
        return 'video';
      }
    }

    // Check story-level type
    final typeStr = story.type?.toString().toLowerCase() ?? '';
    if (typeStr.contains('video')) return 'video';

    if (story.content?.isNotEmpty == true &&
        (story.media == null || story.media!.isEmpty)) {
      return 'text';
    }

    return 'image';
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ACCESSORS
  // ══════════════════════════════════════════════════════════════════════════

  /// The group currently open in the viewer.
  StoryGroup? get currentGroup {
    if (storyGroups.isEmpty) return null;
    if (currentGroupIndex.value >= storyGroups.length) return null;
    return storyGroups[currentGroupIndex.value];
  }

  /// The individual story currently showing in the viewer.
  UnifiedStory? getCurrentStory() {
    final group = currentGroup;
    if (group == null || group.stories.isEmpty) return null;
    if (currentStoryIndex.value >= group.stories.length) return null;
    return group.stories[currentStoryIndex.value];
  }

  /// Friend groups only (excludes index 0 which is always My Story).
  List<StoryGroup> get friendGroups =>
      storyGroups.length > 1 ? storyGroups.sublist(1) : [];

  /// The My Story group (always index 0).
  StoryGroup get myGroup => storyGroups.isNotEmpty
      ? storyGroups[0]
      : StoryGroup(userId: 0, stories: [], isMyGroup: true);

  bool hasMyStory() => myGroup.stories.isNotEmpty;

  bool hasAnyStories() => friendGroups.isNotEmpty;

  bool isMyStory() => currentGroup?.isMyGroup == true;

  bool isStoryViewed(int? postId) {
    if (postId == null) return false;
    return viewedStories.contains(postId);
  }

  bool isGroupFullyViewed(StoryGroup group) =>
      group.stories.every((s) => isStoryViewed(s.postId));

  // ══════════════════════════════════════════════════════════════════════════
  //  NAVIGATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Opens the story viewer starting at [groupIndex].
  void openGroupAtIndex(int groupIndex) {
    if (groupIndex >= storyGroups.length) return;
    currentGroupIndex.value = groupIndex;
    currentStoryIndex.value = 0;
    storyProgress.value = 0.0;
  }

  /// Opens My Story group (index 0).
  void openMyStory() => openGroupAtIndex(0);

  void startStoryTimer({int? overrideDuration}) {
    _timer?.cancel();
    storyProgress.value = 0.0;

    final duration = overrideDuration ?? storyDuration;
    // 50 ms tick → increment per tick = 1 / (duration * 1000 / 50)
    final increment = 0.05 / duration;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      storyProgress.value += increment;
      if (storyProgress.value >= 1.0) {
        storyProgress.value = 1.0;
        nextStory();
      }
    });
  }

  void pauseStory() => _timer?.cancel();

  void resumeStory() {
    if (storyProgress.value < 1.0) startStoryTimer();
  }

  void nextStory() {
    _timer?.cancel();
    final group = currentGroup;
    if (group == null) {
      Get.back();
      return;
    }

    _markCurrentViewed();

    if (currentStoryIndex.value < group.stories.length - 1) {
      currentStoryIndex.value++;
      storyProgress.value = 0.0;
      startStoryTimer();
    } else {
      _nextGroup();
    }
  }

  void previousStory() {
    _timer?.cancel();
    if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
      storyProgress.value = 0.0;
      startStoryTimer();
    } else {
      _previousGroup();
    }
  }

  void _nextGroup() {
    if (currentGroupIndex.value < storyGroups.length - 1) {
      currentGroupIndex.value++;
      currentStoryIndex.value = 0;
      storyProgress.value = 0.0;
      startStoryTimer();
    } else {
      Get.back();
    }
  }

  void _previousGroup() {
    if (currentGroupIndex.value > 0) {
      currentGroupIndex.value--;
      final group = storyGroups[currentGroupIndex.value];
      currentStoryIndex.value =
          (group.stories.length - 1).clamp(0, group.stories.length - 1);
      storyProgress.value = 0.0;
      startStoryTimer();
    } else {
      // Already at the very first story – restart it
      currentStoryIndex.value = 0;
      storyProgress.value = 0.0;
      startStoryTimer();
    }
  }

  void onStoryTap(TapUpDetails details, double screenWidth) {
    if (details.globalPosition.dx < screenWidth / 2) {
      previousStory();
    } else {
      nextStory();
    }
  }

  void onLongPressStart() => pauseStory();
  void onLongPressEnd() => resumeStory();

  // ══════════════════════════════════════════════════════════════════════════
  //  VIEWED TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  void _markCurrentViewed() {
    final story = getCurrentStory();
    if (story?.postId != null) {
      viewedStories.add(story!.postId!);
    }
  }

  void markCurrentStoryAsViewed() => _markCurrentViewed();

  // ══════════════════════════════════════════════════════════════════════════
  //  MISC FEATURES
  // ══════════════════════════════════════════════════════════════════════════

  void toggleMute() => isMuted.value = !isMuted.value;

  Future<void> likeStory() async {
    try {
      final story = getCurrentStory();
      if (story == null) return;
      await BaseClient.post(api: EndPoint.like);
      LoggerUtils.warning("Story liked");
    } catch (e) {
      LoggerUtils.error("likeStory error: $e");
    }
  }

  Future<void> sendReply(String message) async {
    try {
      final story = getCurrentStory();
      if (story == null || message.trim().isEmpty) return;
      
      LoggerUtils.warning("Reply sent: $message");
    } catch (e) {
      LoggerUtils.error("sendReply error: $e");
    }
  }

  Future<void> shareStory() async {
    Get.snackbar('Share', 'Story sharing coming soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white.withOpacity(0.2),
        colorText: Colors.white);
  }

  Future<void> reportStory() async {
    Get.snackbar('Reported', 'Story has been reported',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> blockUser() async {
    Get.snackbar('Blocked', 'User has been blocked',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> muteUserStories() async {
    Get.snackbar('Muted', 'You will no longer see stories from this user',
        snackPosition: SnackPosition.BOTTOM);
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:social_book/app/core/utils/logger_utils.dart';
// import 'package:social_book/app/data/baseclient/base_client.dart';
// import 'package:social_book/app/data/endpoint/end_pont.dart';
// import 'package:social_book/app/data/models/post/my_post_model.dart';
// import 'package:social_book/app/data/models/story/story_model.dart';
// import 'package:social_book/app/services/storage/local_storage_service.dart';

// class StoryController extends GetxController {
//   Rxn<StoryModel> storyModel = Rxn<StoryModel>();
//   Rxn<MyPostModel> myStoryModel = Rxn<MyPostModel>();
//   final isLoading = false.obs;
//   final hasError = false.obs;
//   final errorMessage = ''.obs;

//   // Current story viewing state
//   final currentUserIndex = 0.obs;
//   final currentStoryIndex = 0.obs;
//   final storyProgress = 0.0.obs;

//   // Additional features
//   final viewedStories = <int>{}.obs;
//   final isMuted = false.obs;
//   final currentStoryViewCount = 0.obs;

//   Timer? _timer;
//   final storyDuration = 5; // seconds per story

//   // Grouped stories by user
//   RxMap<int, List<StoryData>> groupedStories = <int, List<StoryData>>{}.obs;
//   RxList<int> userIds = <int>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMyStory();
//     fetchStory();
//     _loadViewedStories();
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }

//    Future<void> fetchMyStory() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;
//       final userId = LocalStorageService.getUserId();
//       final profileId = LocalStorageService.getProfileId();
//       final res = await BaseClient.get(
//         api:
//             "${EndPoint.getMyPost}?userId=$userId&profileId=$profileId&search=&PostType=Story&pageNumber=1&pageSize=10000",
//       );

//       if (res != null && res.statusCode == 200) {
//         myStoryModel.value = myPostModelFromJson(json.encode(res.data));
//        log("myStoryModel.value ${myStoryModel.value}");
//       } else {
//         hasError.value = true;
//         errorMessage.value = "Failed to load stories";
//         LoggerUtils.error("Response Failed: ${res?.data}");
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = "Error loading stories";
//       LoggerUtils.error("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }


//   Future<void> fetchStory() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;
//       final userId = LocalStorageService.getUserId();
//       final profileId = LocalStorageService.getProfileId();
//       final res = await BaseClient.get(
//         api:
//             "${EndPoint.searchStory}?userId=$userId&profileId=$profileId&search=&PostType=Story&pageNumber=1&pageSize=10000",
//       );

//       if (res != null && res.statusCode == 200) {
//         storyModel.value = storyModelFromJson(json.encode(res.data));
//         _groupStoriesByUser();
//       } else {
//         hasError.value = true;
//         errorMessage.value = "Failed to load stories";
//         LoggerUtils.error("Response Failed: ${res?.data}");
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = "Error loading stories";
//       LoggerUtils.error("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _groupStoriesByUser() {
//     if (storyModel.value?.storyData == null) return;

//     final Map<int, List<StoryData>> grouped = {};

//     for (var story in storyModel.value!.storyData!) {
//       final userId = story.userId ?? 0;
//       if (!grouped.containsKey(userId)) {
//         grouped[userId] = [];
//       }
//       grouped[userId]!.add(story);
//     }

//     groupedStories.value = grouped;
//     userIds.value = grouped.keys.toList();

//     LoggerUtils.warning("Grouped ${userIds.length} users with stories");
//   }

//   // ==================== STORY NAVIGATION ====================
  
//   List<StoryData>? getCurrentUserStories() {
//     if (userIds.isEmpty || currentUserIndex.value >= userIds.length) {
//       return null;
//     }
//     final userId = userIds[currentUserIndex.value];
//     return groupedStories[userId];
//   }

//   StoryData? getCurrentStory() {
//     final stories = getCurrentUserStories();
//     if (stories == null || stories.isEmpty) return null;
//     if (currentStoryIndex.value >= stories.length) return null;
//     return stories[currentStoryIndex.value];
//   }

//   StoryData? getStoryForUser(int userIndex) {
//     if (userIndex >= userIds.length) return null;
//     final userId = userIds[userIndex];
//     final stories = groupedStories[userId];
//     return stories?.isNotEmpty == true ? stories!.first : null;
//   }

//   void openStoryAtIndex(int userIndex) {
//     if (userIndex >= userIds.length) return;
//     currentUserIndex.value = userIndex;
//     currentStoryIndex.value = 0;
//     storyProgress.value = 0.0;
//   }

//   void startStoryTimer() {
//     _timer?.cancel();
//     storyProgress.value = 0.0;

//     _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       storyProgress.value += 0.05 / storyDuration;

//       if (storyProgress.value >= 1.0) {
//         nextStory();
//       }
//     });
//   }

//   void pauseStory() {
//     _timer?.cancel();
//   }

//   void resumeStory() {
//     if (storyProgress.value < 1.0) {
//       startStoryTimer();
//     }
//   }

//   void nextStory() {
//     final stories = getCurrentUserStories();
//     if (stories == null) {
//       Get.back();
//       return;
//     }

//     if (currentStoryIndex.value < stories.length - 1) {
//       currentStoryIndex.value++;
//       startStoryTimer();
//       markCurrentStoryAsViewed();
//     } else {
//       nextUser();
//     }
//   }

//   void previousStory() {
//     if (currentStoryIndex.value > 0) {
//       currentStoryIndex.value--;
//       startStoryTimer();
//     } else {
//       previousUser();
//     }
//   }

//   void nextUser() {
//     _timer?.cancel();

//     if (currentUserIndex.value < userIds.length - 1) {
//       currentUserIndex.value++;
//       currentStoryIndex.value = 0;
//       startStoryTimer();
//       markCurrentStoryAsViewed();
//     } else {
//       Get.back();
//     }
//   }

//   void previousUser() {
//     _timer?.cancel();

//     if (currentUserIndex.value > 0) {
//       currentUserIndex.value--;
//       final stories = getCurrentUserStories();
//       currentStoryIndex.value = (stories?.length ?? 1) - 1;
//       startStoryTimer();
//     } else {
//       currentStoryIndex.value = 0;
//       startStoryTimer();
//     }
//   }

//   void onStoryTap(TapUpDetails details, double screenWidth) {
//     final double dx = details.globalPosition.dx;

//     if (dx < screenWidth / 2) {
//       previousStory();
//     } else {
//       nextStory();
//     }
//   }

//   void onLongPressStart() {
//     pauseStory();
//   }

//   void onLongPressEnd() {
//     resumeStory();
//   }

//   // ==================== STORY FEATURES ====================

//   bool isStoryViewed(int userId) {
//     return viewedStories.contains(userId);
//   }

//   void markCurrentStoryAsViewed() {
//     if (userIds.isNotEmpty && currentUserIndex.value < userIds.length) {
//       final userId = userIds[currentUserIndex.value];
//       viewedStories.add(userId);
//       _saveViewedStories();
//     }
//   }

//   void _loadViewedStories() {
//     // Load from local storage
//     // final viewed = LocalStorageService.getViewedStories();
//     // if (viewed != null) {
//     //   viewedStories.addAll(viewed);
//     // }
//   }

//   void _saveViewedStories() {
//     // LocalStorageService.saveViewedStories(viewedStories.toList());
//   }

//   bool hasMyStory() {
//     final myUserId = LocalStorageService.getUserId();
//     return groupedStories.containsKey(myUserId);
//   }

//   void openMyStory() {
//     final myUserId = LocalStorageService.getUserId();
//     final index = userIds.indexOf(myUserId);
//     if (index != -1) {
//       openStoryAtIndex(index);
//     }
//   }

//   bool isMyStory() {
//     if (userIds.isEmpty || currentUserIndex.value >= userIds.length) {
//       return false;
//     }
//     final currentUserId = userIds[currentUserIndex.value];
//     final myUserId = LocalStorageService.getUserId();
//     return currentUserId == myUserId;
//   }

//   void toggleMute() {
//     isMuted.value = !isMuted.value;
//   }

//   // ==================== STORY INTERACTIONS ====================

//   Future<void> likeStory() async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       // API call to like story
//       final response = await BaseClient.post(
//         api: EndPoint.like,
//         // body: {
//         //   'storyId': story.id,
//         //   'userId': LocalStorageService.getUserId(),
//         // },
//       );

//       if (response?.statusCode == 200) {
//         LoggerUtils.warning("Story liked successfully");
//       }
//     } catch (e) {
//       LoggerUtils.error("Error liking story: $e");
//     }
//   }

//   Future<void> sendReply(String message) async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       // API call to send reply
//       // final response = await BaseClient.post(
//       //   api: EndPoint.replyToStory,
//       //   body: {
//       //     'storyId': story.id,
//       //     'userId': LocalStorageService.getUserId(),
//       //     'message': message,
//       //   },
//       // );

//       // if (response?.statusCode == 200) {
//       //   LoggerUtils.info("Reply sent successfully");
//       // }
//     } catch (e) {
//       LoggerUtils.error("Error sending reply: $e");
//     }
//   }

//   Future<void> shareStory() async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       // Implement share functionality
//       Get.snackbar(
//         'Share',
//         'Story sharing feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.white.withOpacity(0.2),
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error sharing story: $e");
//     }
//   }

//   Future<void> reportStory() async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       Get.snackbar(
//         'Reported',
//         'Story has been reported',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error reporting story: $e");
//     }
//   }

//   Future<void> blockUser() async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       Get.snackbar(
//         'Blocked',
//         'User has been blocked',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error blocking user: $e");
//     }
//   }

//   Future<void> muteUserStories() async {
//     try {
//       final story = getCurrentStory();
//       if (story == null) return;

//       Get.snackbar(
//         'Muted',
//         'You will no longer see stories from this user',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error muting user stories: $e");
//     }
//   }

//   // ==================== STORY CREATION ====================

//   Future<void> pickImageFromGallery() async {
//     try {
//       // Implement image picker
//       Get.snackbar(
//         'Gallery',
//         'Image picker feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error picking image: $e");
//     }
//   }

//   Future<void> takePhoto() async {
//     try {
//       // Implement camera
//       Get.snackbar(
//         'Camera',
//         'Camera feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error taking photo: $e");
//     }
//   }

//   Future<void> recordVideo() async {
//     try {
//       // Implement video recorder
//       Get.snackbar(
//         'Video',
//         'Video recorder feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       LoggerUtils.error("Error recording video: $e");
//     }
//   }

//   // ==================== UTILITY METHODS ====================

//   String getStoryType(StoryData story) {
//     final typeStr = story.type?.toString().toLowerCase() ?? '';

//     if (typeStr.contains('image')) {
//       return 'image';
//     } else if (typeStr.contains('video')) {
//       return 'video';
//     }

//     if (story.media?.isNotEmpty == true) {
//       final mediaType = story.media!.first.type?.toString().toLowerCase() ?? '';
//       if (mediaType.contains('video')) {
//         return 'video';
//       }
//     }

//     return 'image';
//   }

//   bool isVideo(StoryData story) {
//     return getStoryType(story) == 'video';
//   }

//   bool hasStories() {
//     return userIds.isNotEmpty;
//   }

//   int getTotalStoryCount() {
//     return storyModel.value?.storyData?.length ?? 0;
//   }
  
// }


