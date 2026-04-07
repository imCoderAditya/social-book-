// To parse this JSON data, do
//
//     final myPostModel = myPostModelFromJson(jsonString);

import 'dart:convert';

MyPostModel myPostModelFromJson(String str) => MyPostModel.fromJson(json.decode(str));

String myPostModelToJson(MyPostModel data) => json.encode(data.toJson());

class MyPostModel {
    final bool? success;
    final String? message;
    final List<MyPostData>? myPostData;
    final Pagination? pagination;

    MyPostModel({
        this.success,
        this.message,
        this.myPostData,
        this.pagination,
    });

    MyPostModel copyWith({
        bool? success,
        String? message,
        List<MyPostData>? myPostData,
        Pagination? pagination,
    }) => 
        MyPostModel(
            success: success ?? this.success,
            message: message ?? this.message,
            myPostData: myPostData ?? this.myPostData,
            pagination: pagination ?? this.pagination,
        );

    factory MyPostModel.fromJson(Map<String, dynamic> json) => MyPostModel(
        success: json["success"],
        message: json["message"],
        myPostData: json["data"] == null ? [] : List<MyPostData>.from(json["data"]!.map((x) => MyPostData.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": myPostData == null ? [] : List<dynamic>.from(myPostData!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class MyPostData {
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
    final List<String>? mediaUrl;
    final String? thumbnailUrl;
    final String? location;
    final double? latitude;
    final double? longitude;
    final String? createdAt;
    final int? totalLikes;
    final int? interestMatchScore;
    final String? myReactionType;
    final int? commentsCount;

    MyPostData({
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
        this.totalLikes,
        this.interestMatchScore,
        this.myReactionType,
        this.commentsCount,
    });

    MyPostData copyWith({
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
        List<String>? mediaUrl,
        String? thumbnailUrl,
        String? location,
        double? latitude,
        double? longitude,
        String? createdAt,
        int? totalLikes,
        int? interestMatchScore,
        String? myReactionType,
        int? commentsCount,
    }) => 
        MyPostData(
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
            totalLikes: totalLikes ?? this.totalLikes,
            interestMatchScore: interestMatchScore ?? this.interestMatchScore,
            myReactionType: myReactionType ?? this.myReactionType,
            commentsCount: commentsCount ?? this.commentsCount,
        );

    factory MyPostData.fromJson(Map<String, dynamic> json) => MyPostData(
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
        mediaUrl: json["MediaURL"] == null ? [] : List<String>.from(json["MediaURL"]!.map((x) => x)),
        thumbnailUrl: json["ThumbnailURL"],
        location: json["Location"],
        latitude: json["Latitude"]?.toDouble(),
        longitude: json["Longitude"]?.toDouble(),
        createdAt: json["CreatedAt"],
        totalLikes: json["TotalLikes"],
        interestMatchScore: json["InterestMatchScore"],
        myReactionType: json["MyReactionType"],
        commentsCount: json["CommentsCount"],
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
        "MediaURL": mediaUrl == null ? [] : List<dynamic>.from(mediaUrl!.map((x) => x)),
        "ThumbnailURL": thumbnailUrl,
        "Location": location,
        "Latitude": latitude,
        "Longitude": longitude,
        "CreatedAt": createdAt,
        "TotalLikes": totalLikes,
        "InterestMatchScore": interestMatchScore,
        "MyReactionType": myReactionType,
        "CommentsCount": commentsCount,
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
