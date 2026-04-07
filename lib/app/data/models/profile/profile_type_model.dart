// To parse this JSON data, do
//
//     final profileTypeModel = profileTypeModelFromJson(jsonString);

import 'dart:convert';

ProfileTypeModel profileTypeModelFromJson(String str) => ProfileTypeModel.fromJson(json.decode(str));

String profileTypeModelToJson(ProfileTypeModel data) => json.encode(data.toJson());

class ProfileTypeModel {
    final bool? success;
    final String? message;
    final List<ProfileType>? profiles;

    ProfileTypeModel({
        this.success,
        this.message,
        this.profiles,
    });

    ProfileTypeModel copyWith({
        bool? success,
        String? message,
        List<ProfileType>? profiles,
    }) => 
        ProfileTypeModel(
            success: success ?? this.success,
            message: message ?? this.message,
            profiles: profiles ?? this.profiles,
        );

    factory ProfileTypeModel.fromJson(Map<String, dynamic> json) => ProfileTypeModel(
        success: json["success"],
        message: json["message"],
        profiles: json["profiles"] == null ? [] : List<ProfileType>.from(json["profiles"]!.map((x) => ProfileType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "profiles": profiles == null ? [] : List<dynamic>.from(profiles!.map((x) => x.toJson())),
    };
}

class ProfileType {
    final String? type;
    final int? profileId;
    final String? displayName;
    final String? bio;
    final String? profilePicture;
    final String? coverImage;
    final String? color;
    final String? icon;
    final String? description;

    ProfileType({
        this.type,
        this.profileId,
        this.displayName,
        this.bio,
        this.profilePicture,
        this.coverImage,
        this.color,
        this.icon,
        this.description,
    });

    ProfileType copyWith({
        String? type,
        int? profileId,
        String? displayName,
        String? bio,
        String? profilePicture,
        String? coverImage,
        String? color,
        String? icon,
        String? description,
    }) => 
        ProfileType(
            type: type ?? this.type,
            profileId: profileId ?? this.profileId,
            displayName: displayName ?? this.displayName,
            bio: bio ?? this.bio,
            profilePicture: profilePicture ?? this.profilePicture,
            coverImage: coverImage ?? this.coverImage,
            color: color ?? this.color,
            icon: icon ?? this.icon,
            description: description ?? this.description,
        );

    factory ProfileType.fromJson(Map<String, dynamic> json) => ProfileType(
        type: json["type"],
        profileId: json["profileId"],
        displayName: json["displayName"],
        bio: json["bio"],
        profilePicture: json["profilePicture"],
        coverImage: json["coverImage"],
        color: json["color"],
        icon: json["icon"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "profileId": profileId,
        "displayName": displayName,
        "bio": bio,
        "profilePicture": profilePicture,
        "coverImage": coverImage,
        "color": color,
        "icon": icon,
        "description": description,
    };
}
