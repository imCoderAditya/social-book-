// To parse this JSON data, do
//
//     final reelModel = reelModelFromJson(jsonString);

import 'dart:convert';

ReelModel reelModelFromJson(String str) => ReelModel.fromJson(json.decode(str));

String reelModelToJson(ReelModel data) => json.encode(data.toJson());

class ReelModel {
  final bool? success;
  final String? message;
  final List<ReelData>? reel;
  final Pagination? pagination;

  ReelModel({this.success, this.message, this.reel, this.pagination});

  ReelModel copyWith({
    bool? success,
    String? message,
    List<ReelData>? reel,
    Pagination? pagination,
  }) => ReelModel(
    success: success ?? this.success,
    message: message ?? this.message,
    reel: reel ?? this.reel,
    pagination: pagination ?? this.pagination,
  );

  factory ReelModel.fromJson(Map<String, dynamic> json) => ReelModel(
    success: json["success"],
    message: json["message"],
    reel:
        json["data"] == null
            ? []
            : List<ReelData>.from(
              json["data"]!.map((x) => ReelData.fromJson(x)),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        reel == null ? [] : List<dynamic>.from(reel!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class ReelData {
  final int? rowNum;
  final int? postId;
  final int? userId;
  final int? profileId;
  final String? displayName;
  final String? profilePicture;
  final String? profession;
  final String? content;
  final String? postType;
  final String? privacyLevel;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final int? interestMatchScore;
  final String? myReactionType;
  final int? commentsCount;
  int? totalLikes;
  final ReactionCounts? reactionCounts;
  final bool? isLiked;

  ReelData({
    this.rowNum,
    this.postId,
    this.userId,
    this.profileId,
    this.displayName,
    this.profilePicture,
    this.profession,
    this.content,
    this.postType,
    this.privacyLevel,
    this.mediaUrl,
    this.thumbnailUrl,
    this.location,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.interestMatchScore,
    this.myReactionType,
    this.commentsCount,
    this.totalLikes,
    this.reactionCounts,
    this.isLiked,
  });

  ReelData copyWith({
    int? rowNum,
    int? postId,
    int? userId,
    int? profileId,
    String? displayName,
    String? profilePicture,
    String? profession,
    String? content,
    String? postType,
    String? privacyLevel,
    String? mediaUrl,
    String? thumbnailUrl,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    int? interestMatchScore,
    String? myReactionType,
    int? commentsCount,
    int? totalLikes,
    ReactionCounts? reactionCounts,
    bool? isLiked,
  }) => ReelData(
    rowNum: rowNum ?? this.rowNum,
    postId: postId ?? this.postId,
    userId: userId ?? this.userId,
    profileId: profileId ?? this.profileId,
    displayName: displayName ?? this.displayName,
    profilePicture: profilePicture ?? this.profilePicture,
    profession: profession ?? this.profession,
    content: content ?? this.content,
    postType: postType ?? this.postType,
    privacyLevel: privacyLevel ?? this.privacyLevel,
    mediaUrl: mediaUrl ?? this.mediaUrl,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    location: location ?? this.location,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
    interestMatchScore: interestMatchScore ?? this.interestMatchScore,
    myReactionType: myReactionType ?? this.myReactionType,
    commentsCount: commentsCount ?? this.commentsCount,
    totalLikes: totalLikes ?? this.totalLikes,
    reactionCounts: reactionCounts ?? this.reactionCounts,
    isLiked: isLiked ?? this.isLiked,
  );

  factory ReelData.fromJson(Map<String, dynamic> json) => ReelData(
    rowNum: json["RowNum"],
    postId: json["PostID"],
    userId: json["UserID"],
    profileId: json["ProfileID"],
    displayName: json["DisplayName"],
    profilePicture: json["ProfilePicture"],
    profession: json["Profession"],
    content: json["Content"],
    postType: json["PostType"],
    privacyLevel: json["PrivacyLevel"],
    mediaUrl: json["MediaURL"],
    thumbnailUrl: json["ThumbnailURL"],
    location: json["Location"],
    latitude: json["Latitude"]?.toDouble(),
    longitude: json["Longitude"]?.toDouble(),
    createdAt:
        json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    interestMatchScore: json["InterestMatchScore"],
    myReactionType: json["MyReactionType"],
    commentsCount: json["CommentsCount"],
    totalLikes: json["TotalLikes"],
    // ✅ THIS IS THE FIX
    isLiked: json["MyReactionType"] == "Like",
    reactionCounts:
        json["ReactionCounts"] == null
            ? null
            : ReactionCounts.fromJson(json["ReactionCounts"]),
  );

  Map<String, dynamic> toJson() => {
    "RowNum": rowNum,
    "PostID": postId,
    "UserID": userId,
    "ProfileID": profileId,
    "DisplayName": displayName,
    "ProfilePicture": profilePicture,
    "Profession": profession,
    "Content": content,
    "PostType": postType,
    "PrivacyLevel": privacyLevel,
    "MediaURL": mediaUrl,
    "ThumbnailURL": thumbnailUrl,
    "Location": location,
    "Latitude": latitude,
    "Longitude": longitude,
    "CreatedAt": createdAt?.toIso8601String(),
    "InterestMatchScore": interestMatchScore,
    "MyReactionType": myReactionType,
    "CommentsCount": commentsCount,
    "TotalLikes": totalLikes,
    "ReactionCounts": reactionCounts?.toJson(),
  };
}

class ReactionCounts {
  final int? likeCount;
  final int? loveCount;
  final int? hahaCount;
  final int? wowCount;
  final int? sadCount;
  final int? angryCount;

  ReactionCounts({
    this.likeCount,
    this.loveCount,
    this.hahaCount,
    this.wowCount,
    this.sadCount,
    this.angryCount,
  });

  ReactionCounts copyWith({
    int? likeCount,
    int? loveCount,
    int? hahaCount,
    int? wowCount,
    int? sadCount,
    int? angryCount,
  }) => ReactionCounts(
    likeCount: likeCount ?? this.likeCount,
    loveCount: loveCount ?? this.loveCount,
    hahaCount: hahaCount ?? this.hahaCount,
    wowCount: wowCount ?? this.wowCount,
    sadCount: sadCount ?? this.sadCount,
    angryCount: angryCount ?? this.angryCount,
  );

  factory ReactionCounts.fromJson(Map<String, dynamic> json) => ReactionCounts(
    likeCount: json["LikeCount"],
    loveCount: json["LoveCount"],
    hahaCount: json["HahaCount"],
    wowCount: json["WowCount"],
    sadCount: json["SadCount"],
    angryCount: json["AngryCount"],
  );

  Map<String, dynamic> toJson() => {
    "LikeCount": likeCount,
    "LoveCount": loveCount,
    "HahaCount": hahaCount,
    "WowCount": wowCount,
    "SadCount": sadCount,
    "AngryCount": angryCount,
  };
}

class Pagination {
  final int? pageNumber;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;

  Pagination({
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.totalPages,
  });

  Pagination copyWith({
    int? pageNumber,
    int? pageSize,
    int? totalCount,
    int? totalPages,
  }) => Pagination(
    pageNumber: pageNumber ?? this.pageNumber,
    pageSize: pageSize ?? this.pageSize,
    totalCount: totalCount ?? this.totalCount,
    totalPages: totalPages ?? this.totalPages,
  );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalCount": totalCount,
    "totalPages": totalPages,
  };
}
