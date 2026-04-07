// To parse this JSON data, do
//
//     final onlineUserModel = onlineUserModelFromJson(jsonString);

import 'dart:convert';

OnlineUserModel onlineUserModelFromJson(String str) => OnlineUserModel.fromJson(json.decode(str));

String onlineUserModelToJson(OnlineUserModel data) => json.encode(data.toJson());

class OnlineUserModel {
    final String? type;
    final int? profileId;
    final String? sessionType;
    final int? pageNumber;
    final int? pageSize;
    final int? count;
    final List<OnlineUser>? onlineUser;

    OnlineUserModel({
        this.type,
        this.profileId,
        this.sessionType,
        this.pageNumber,
        this.pageSize,
        this.count,
        this.onlineUser,
    });

    OnlineUserModel copyWith({
        String? type,
        int? profileId,
        String? sessionType,
        int? pageNumber,
        int? pageSize,
        int? count,
        List<OnlineUser>? onlineUser,
    }) => 
        OnlineUserModel(
            type: type ?? this.type,
            profileId: profileId ?? this.profileId,
            sessionType: sessionType ?? this.sessionType,
            pageNumber: pageNumber ?? this.pageNumber,
            pageSize: pageSize ?? this.pageSize,
            count: count ?? this.count,
            onlineUser: onlineUser ?? this.onlineUser,
        );

    factory OnlineUserModel.fromJson(Map<String, dynamic> json) => OnlineUserModel(
        type: json["type"],
        profileId: json["profileId"],
        sessionType: json["sessionType"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        count: json["count"],
        onlineUser: json["sessions"] == null ? [] : List<OnlineUser>.from(json["sessions"]!.map((x) => OnlineUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "profileId": profileId,
        "sessionType": sessionType,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "count": count,
        "sessions": onlineUser == null ? [] : List<dynamic>.from(onlineUser!.map((x) => x.toJson())),
    };
}

class OnlineUser {
    final int? sessionId;
    final String? sessionType;
    final String? sessionStatus;
    final String? lastMessage;
    final DateTime? lastMessageAt;
    final int? myProfileId;
    final String? myDisplayName;
    final String? myProfilePicture;
    final bool? myLiveStatus;
    final int? otherProfileId;
    final String? otherDisplayName;
    final String? otherProfilePicture;
    final bool? otherLiveStatus;
    final String? combinedStatus;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    OnlineUser({
        this.sessionId,
        this.sessionType,
        this.sessionStatus,
        this.lastMessage,
        this.lastMessageAt,
        this.myProfileId,
        this.myDisplayName,
        this.myProfilePicture,
        this.myLiveStatus,
        this.otherProfileId,
        this.otherDisplayName,
        this.otherProfilePicture,
        this.otherLiveStatus,
        this.combinedStatus,
        this.createdAt,
        this.updatedAt,
    });

    OnlineUser copyWith({
        int? sessionId,
        String? sessionType,
        String? sessionStatus,
        String? lastMessage,
        DateTime? lastMessageAt,
        int? myProfileId,
        String? myDisplayName,
        String? myProfilePicture,
        bool? myLiveStatus,
        int? otherProfileId,
        String? otherDisplayName,
        String? otherProfilePicture,
        bool? otherLiveStatus,
        String? combinedStatus,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        OnlineUser(
            sessionId: sessionId ?? this.sessionId,
            sessionType: sessionType ?? this.sessionType,
            sessionStatus: sessionStatus ?? this.sessionStatus,
            lastMessage: lastMessage ?? this.lastMessage,
            lastMessageAt: lastMessageAt ?? this.lastMessageAt,
            myProfileId: myProfileId ?? this.myProfileId,
            myDisplayName: myDisplayName ?? this.myDisplayName,
            myProfilePicture: myProfilePicture ?? this.myProfilePicture,
            myLiveStatus: myLiveStatus ?? this.myLiveStatus,
            otherProfileId: otherProfileId ?? this.otherProfileId,
            otherDisplayName: otherDisplayName ?? this.otherDisplayName,
            otherProfilePicture: otherProfilePicture ?? this.otherProfilePicture,
            otherLiveStatus: otherLiveStatus ?? this.otherLiveStatus,
            combinedStatus: combinedStatus ?? this.combinedStatus,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory OnlineUser.fromJson(Map<String, dynamic> json) => OnlineUser(
        sessionId: json["SessionID"],
        sessionType: json["SessionType"],
        sessionStatus: json["SessionStatus"],
        lastMessage: json["LastMessage"],
        lastMessageAt: json["LastMessageAt"] == null ? null : DateTime.parse(json["LastMessageAt"]),
        myProfileId: json["MyProfileID"],
        myDisplayName: json["MyDisplayName"],
        myProfilePicture: json["MyProfilePicture"],
        myLiveStatus: json["MyLiveStatus"],
        otherProfileId: json["OtherProfileID"],
        otherDisplayName: json["OtherDisplayName"],
        otherProfilePicture: json["OtherProfilePicture"],
        otherLiveStatus: json["OtherLiveStatus"],
        combinedStatus: json["CombinedStatus"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "SessionID": sessionId,
        "SessionType": sessionType,
        "SessionStatus": sessionStatus,
        "LastMessage": lastMessage,
        "LastMessageAt": lastMessageAt?.toIso8601String(),
        "MyProfileID": myProfileId,
        "MyDisplayName": myDisplayName,
        "MyProfilePicture": myProfilePicture,
        "MyLiveStatus": myLiveStatus,
        "OtherProfileID": otherProfileId,
        "OtherDisplayName": otherDisplayName,
        "OtherProfilePicture": otherProfilePicture,
        "OtherLiveStatus": otherLiveStatus,
        "CombinedStatus": combinedStatus,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
    };
}
