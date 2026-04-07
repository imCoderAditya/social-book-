// To parse this JSON data, do
//
//     final reelCommentModel = reelCommentModelFromJson(jsonString);

import 'dart:convert';

ReelCommentModel reelCommentModelFromJson(String str) => ReelCommentModel.fromJson(json.decode(str));

String reelCommentModelToJson(ReelCommentModel data) => json.encode(data.toJson());

class ReelCommentModel {
    final bool? success;
    final String? message;
    final Data? data;

    ReelCommentModel({
        this.success,
        this.message,
        this.data,
    });

    ReelCommentModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        ReelCommentModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ReelCommentModel.fromJson(Map<String, dynamic> json) => ReelCommentModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? postId;
    final int? profileId;
    final int? userId;
    final List<Comment>? comments;
    final Pagination? pagination;

    Data({
        this.postId,
        this.profileId,
        this.userId,
        this.comments,
        this.pagination,
    });

    Data copyWith({
        int? postId,
        int? profileId,
        int? userId,
        List<Comment>? comments,
        Pagination? pagination,
    }) => 
        Data(
            postId: postId ?? this.postId,
            profileId: profileId ?? this.profileId,
            userId: userId ?? this.userId,
            comments: comments ?? this.comments,
            pagination: pagination ?? this.pagination,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        postId: json["postId"],
        profileId: json["profileId"],
        userId: json["userId"],
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "postId": postId,
        "profileId": profileId,
        "userId": userId,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Comment {
    final int? commentId;
    final int? parentCommentId;
    final String? commentText;
    final String? mediaUrl;
    final String? createdAt;
    final String? updatedAt;
    final int? level;
    final String? sortPath;
    final String? displayName;
    final String? profilePicture;
    final int? userId;
    final int? profileId;
    final String? myReactionType;
    final int? loveReactionCount;
    final List<Comment>? replies;

    Comment({
        this.commentId,
        this.parentCommentId,
        this.commentText,
        this.mediaUrl,
        this.createdAt,
        this.updatedAt,
        this.level,
        this.sortPath,
        this.displayName,
        this.profilePicture,
        this.userId,
        this.profileId,
        this.myReactionType,
        this.loveReactionCount,
        this.replies,
    });

    Comment copyWith({
        int? commentId,
        int? parentCommentId,
        String? commentText,
        String? mediaUrl,
        String? createdAt,
        String? updatedAt,
        int? level,
        String? sortPath,
        String? displayName,
        String? profilePicture,
        int? userId,
        int? profileId,
        String? myReactionType,
        int? loveReactionCount,
        List<Comment>? replies,
    }) => 
        Comment(
            commentId: commentId ?? this.commentId,
            parentCommentId: parentCommentId ?? this.parentCommentId,
            commentText: commentText ?? this.commentText,
            mediaUrl: mediaUrl ?? this.mediaUrl,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            level: level ?? this.level,
            sortPath: sortPath ?? this.sortPath,
            displayName: displayName ?? this.displayName,
            profilePicture: profilePicture ?? this.profilePicture,
            userId: userId ?? this.userId,
            profileId: profileId ?? this.profileId,
            myReactionType: myReactionType ?? this.myReactionType,
            loveReactionCount: loveReactionCount ?? this.loveReactionCount,
            replies: replies ?? this.replies,
        );

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["CommentID"],
        parentCommentId: json["ParentCommentID"],
        commentText: json["CommentText"],
        mediaUrl: json["MediaURL"],
        createdAt: json["CreatedAt"],
        updatedAt: json["UpdatedAt"],
        level: json["Level"],
        sortPath: json["SortPath"],
        displayName: json["DisplayName"],
        profilePicture: json["ProfilePicture"],
        userId: json["UserID"],
        profileId: json["ProfileID"],
        myReactionType: json["MyReactionType"],
        loveReactionCount: json["LoveReactionCount"],
        replies: json["Replies"] == null ? [] : List<Comment>.from(json["Replies"]!.map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "CommentID": commentId,
        "ParentCommentID": parentCommentId,
        "CommentText": commentText,
        "MediaURL": mediaUrl,
        "CreatedAt": createdAt,
        "UpdatedAt": updatedAt,
        "Level": level,
        "SortPath": sortPath,
        "DisplayName": displayName,
        "ProfilePicture": profilePicture,
        "UserID": userId,
        "ProfileID": profileId,
        "MyReactionType": myReactionType,
        "LoveReactionCount": loveReactionCount,
        "Replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
    };
}

class Pagination {
    final int? pageNumber;
    final int? pageSize;
    final int? totalComments;
    final int? totalPages;
    final int? currentPageComments;

    Pagination({
        this.pageNumber,
        this.pageSize,
        this.totalComments,
        this.totalPages,
        this.currentPageComments,
    });

    Pagination copyWith({
        int? pageNumber,
        int? pageSize,
        int? totalComments,
        int? totalPages,
        int? currentPageComments,
    }) => 
        Pagination(
            pageNumber: pageNumber ?? this.pageNumber,
            pageSize: pageSize ?? this.pageSize,
            totalComments: totalComments ?? this.totalComments,
            totalPages: totalPages ?? this.totalPages,
            currentPageComments: currentPageComments ?? this.currentPageComments,
        );

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalComments: json["totalComments"],
        totalPages: json["totalPages"],
        currentPageComments: json["currentPageComments"],
    );

    Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalComments": totalComments,
        "totalPages": totalPages,
        "currentPageComments": currentPageComments,
    };
}
