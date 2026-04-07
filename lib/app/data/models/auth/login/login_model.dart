// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    final bool? success;
    final Data? data;

    LoginModel({
        this.success,
        this.data,
    });

    LoginModel copyWith({
        bool? success,
        Data? data,
    }) => 
        LoginModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    final String? accessToken;
    final String? refreshToken;
    final int? expiresIn;
    final User? user;

    Data({
        this.accessToken,
        this.refreshToken,
        this.expiresIn,
        this.user,
    });

    Data copyWith({
        String? accessToken,
        String? refreshToken,
        int? expiresIn,
        User? user,
    }) => 
        Data(
            accessToken: accessToken ?? this.accessToken,
            refreshToken: refreshToken ?? this.refreshToken,
            expiresIn: expiresIn ?? this.expiresIn,
            user: user ?? this.user,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["AccessToken"],
        refreshToken: json["RefreshToken"],
        expiresIn: json["ExpiresIn"],
        user: json["User"] == null ? null : User.fromJson(json["User"]),
    );

    Map<String, dynamic> toJson() => {
        "AccessToken": accessToken,
        "RefreshToken": refreshToken,
        "ExpiresIn": expiresIn,
        "User": user?.toJson(),
    };
}

class User {
    final int? userId;
    final String? email;
    final String? phoneNumber;
    final List<Profile>? profiles;

    User({
        this.userId,
        this.email,
        this.phoneNumber,
        this.profiles,
    });

    User copyWith({
        int? userId,
        String? email,
        String? phoneNumber,
        List<Profile>? profiles,
    }) => 
        User(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            profiles: profiles ?? this.profiles,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        profiles: json["profiles"] == null ? [] : List<Profile>.from(json["profiles"]!.map((x) => Profile.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "phoneNumber": phoneNumber,
        "profiles": profiles == null ? [] : List<dynamic>.from(profiles!.map((x) => x.toJson())),
    };
}

class Profile {
    final int? profileId;
    final String? profileType;
    final String? displayName;
    final String? profilePictureUrl;

    Profile({
        this.profileId,
        this.profileType,
        this.displayName,
        this.profilePictureUrl,
    });

    Profile copyWith({
        int? profileId,
        String? profileType,
        String? displayName,
        String? profilePictureUrl,
    }) => 
        Profile(
            profileId: profileId ?? this.profileId,
            profileType: profileType ?? this.profileType,
            displayName: displayName ?? this.displayName,
            profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        );

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["profileId"],
        profileType: json["profileType"],
        displayName: json["displayName"],
        profilePictureUrl: json["profilePictureUrl"],
    );

    Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "profileType": profileType,
        "displayName": displayName,
        "profilePictureUrl": profilePictureUrl,
    };
}
