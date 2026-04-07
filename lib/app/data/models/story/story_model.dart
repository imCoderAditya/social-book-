// To parse this JSON data, do
//
//     final storyModel = storyModelFromJson(jsonString);

import 'dart:convert';

StoryModel storyModelFromJson(String str) => StoryModel.fromJson(json.decode(str));

String storyModelToJson(StoryModel data) => json.encode(data.toJson());

class StoryModel {
    final bool? success;
    final String? message;
    final List<StoryData>? storyData;
    final Pagination? pagination;

    StoryModel({
        this.success,
        this.message,
        this.storyData,
        this.pagination,
    });

    StoryModel copyWith({
        bool? success,
        String? message,
        List<StoryData>? data,
        Pagination? pagination,
    }) => 
        StoryModel(
            success: success ?? this.success,
            message: message ?? this.message,
            storyData: data ?? storyData,
            pagination: pagination ?? this.pagination,
        );

    factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        success: json["success"],
        message: json["message"],
        storyData: json["data"] == null ? [] : List<StoryData>.from(json["data"]!.map((x) => StoryData.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": storyData == null ? [] : List<dynamic>.from(storyData!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class StoryData {
    final int? rowNum;
    final int? postId;
    final int? userId;
    final int? profileId;
    final String? displayName;
    final String? profilePicture;
    final String? profession;
    final String? content;
    final TypeEnum? type;
    final PrivacyLevel? privacyLevel;
    final List<Media>? media;
    final dynamic thumbnailUrl;
    final String? location;
    final double? latitude;
    final double? longitude;
    final DateTime? createdAt;
    final int? interestMatchScore;
    final MyReactionType? myReactionType;
    final int? commentsCount;
    final int? totalLikes;
    final ReactionCounts? reactionCounts;

    StoryData({
        this.rowNum,
        this.postId,
        this.userId,
        this.profileId,
        this.displayName,
        this.profilePicture,
        this.profession,
        this.content,
        this.type,
        this.privacyLevel,
        this.media,
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
    });

    StoryData copyWith({
        int? rowNum,
        int? postId,
        int? userId,
        int? profileId,
        String? displayName,
        String? profilePicture,
        String? profession,
        String? content,
        TypeEnum? type,
        PrivacyLevel? privacyLevel,
        List<Media>? media,
        dynamic thumbnailUrl,
        String? location,
        double? latitude,
        double? longitude,
        DateTime? createdAt,
        int? interestMatchScore,
        MyReactionType? myReactionType,
        int? commentsCount,
        int? totalLikes,
        ReactionCounts? reactionCounts,
    }) => 
        StoryData(
            rowNum: rowNum ?? this.rowNum,
            postId: postId ?? this.postId,
            userId: userId ?? this.userId,
            profileId: profileId ?? this.profileId,
            displayName: displayName ?? this.displayName,
            profilePicture: profilePicture ?? this.profilePicture,
            profession: profession ?? this.profession,
            content: content ?? this.content,
            type: type ?? this.type,
            privacyLevel: privacyLevel ?? this.privacyLevel,
            media: media ?? this.media,
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
        );

    factory StoryData.fromJson(Map<String, dynamic> json) => StoryData(
        rowNum: json["RowNum"],
        postId: json["PostID"],
        userId: json["UserID"],
        profileId: json["ProfileID"],
        displayName: json["DisplayName"],
        profilePicture: json["ProfilePicture"],
        profession: json["Profession"],
        content: json["Content"],
        type: typeEnumValues.map[json["Type"]]!,
        privacyLevel: privacyLevelValues.map[json["PrivacyLevel"]]!,
        media: json["Media"] == null ? [] : List<Media>.from(json["Media"]!.map((x) => Media.fromJson(x))),
        thumbnailUrl: json["ThumbnailURL"],
        location: json["Location"],
        latitude: json["Latitude"]?.toDouble(),
        longitude: json["Longitude"]?.toDouble(),
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        interestMatchScore: json["InterestMatchScore"],
        myReactionType: myReactionTypeValues.map[json["MyReactionType"]]!,
        commentsCount: json["CommentsCount"],
        totalLikes: json["TotalLikes"],
        reactionCounts: json["ReactionCounts"] == null ? null : ReactionCounts.fromJson(json["ReactionCounts"]),
    );

    Map<String, dynamic> toJson() => {
        "RowNum": rowNum,
        "PostID": postId,
        "UserID": userId,
        "ProfileID": profileId,
        "DisplayName": displayName,
        "ProfilePicture": profilePicture,
        "Profession": profession,
        "Content":content,
        "Type": typeEnumValues.reverse[type],
        "PrivacyLevel": privacyLevelValues.reverse[privacyLevel],
        "Media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "ThumbnailURL": thumbnailUrl,
        "Location": location,
        "Latitude": latitude,
        "Longitude": longitude,
        "CreatedAt": createdAt?.toIso8601String(),
        "InterestMatchScore": interestMatchScore,
        "MyReactionType": myReactionTypeValues.reverse[myReactionType],
        "CommentsCount": commentsCount,
        "TotalLikes": totalLikes,
        "ReactionCounts": reactionCounts?.toJson(),
    };
}



class Media {
    final String? url;
    final Type? type;
    final String? extension;

    Media({
        this.url,
        this.type,
        this.extension,
    });

    Media copyWith({
        String? url,
        Type? type,
        String? extension,
    }) => 
        Media(
            url: url ?? this.url,
            type: type ?? this.type,
            extension: extension ?? this.extension,
        );

    factory Media.fromJson(Map<String, dynamic> json) => Media(
        url: json["url"],
        type: typeValues.map[json["type"]]!,
        extension: json["extension"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "type": typeValues.reverse[type],
        "extension": extension,
    };
}

enum Type {
    IMAGE
}

final typeValues = EnumValues({
    "image": Type.IMAGE
});

enum MyReactionType {
    NO_REACTION
}

final myReactionTypeValues = EnumValues({
    "NoReaction": MyReactionType.NO_REACTION
});

enum PrivacyLevel {
    PUBLIC
}

final privacyLevelValues = EnumValues({
    "Public": PrivacyLevel.PUBLIC
});

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
    }) => 
        ReactionCounts(
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

enum TypeEnum {
    IMAGE
}

final typeEnumValues = EnumValues({
    "Image": TypeEnum.IMAGE
});

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
    }) => 
        Pagination(
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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
