// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    final bool? success;
    final String? message;
    final Data? data;

    ProfileModel({
        this.success,
        this.message,
        this.data,
    });

    ProfileModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        ProfileModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    final User? user;
    final List<Profile>? profiles;

    Data({
        this.user,
        this.profiles,
    });

    Data copyWith({
        User? user,
        List<Profile>? profiles,
    }) => 
        Data(
            user: user ?? this.user,
            profiles: profiles ?? this.profiles,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        profiles: json["profiles"] == null ? [] : List<Profile>.from(json["profiles"]!.map((x) => Profile.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "profiles": profiles == null ? [] : List<dynamic>.from(profiles!.map((x) => x.toJson())),
    };
}

class Profile {
    final int? profileId;
    final String? profileType;
    final String? displayName;
    final String? bio;
    final String? profilePicture;
    final String? coverImage;
    final DateTime? dateOfBirth;
    final String? timeOfBirth;
    final String? placeOfBirth;
    final String? gender;
    final String? city;
    final String? state;
    final String? country;
    final String? pincode;
    final String? education;
    final String? profession;
    final String? company;
    final dynamic website;
    final String? privacyLevel;
    final bool? isVerified;
    final dynamic verificationDocument;
    final String? language;
    final bool? isActive;
    final String? whoCanSeePosts;
    final String? whoCanSendFriendRequest;
    final String? whoCanSendMessage;
    final bool? showOnlineStatus;
    final bool? showLastSeen;
    final bool? showDob;
    final bool? showLocation;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Profile({
        this.profileId,
        this.profileType,
        this.displayName,
        this.bio,
        this.profilePicture,
        this.coverImage,
        this.dateOfBirth,
        this.timeOfBirth,
        this.placeOfBirth,
        this.gender,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.education,
        this.profession,
        this.company,
        this.website,
        this.privacyLevel,
        this.isVerified,
        this.verificationDocument,
        this.language,
        this.isActive,
        this.whoCanSeePosts,
        this.whoCanSendFriendRequest,
        this.whoCanSendMessage,
        this.showOnlineStatus,
        this.showLastSeen,
        this.showDob,
        this.showLocation,
        this.createdAt,
        this.updatedAt,
    });

    Profile copyWith({
        int? profileId,
        String? profileType,
        String? displayName,
        String? bio,
        String? profilePicture,
        String? coverImage,
        DateTime? dateOfBirth,
        String? timeOfBirth,
        String? placeOfBirth,
        String? gender,
        String? city,
        String? state,
        String? country,
        String? pincode,
        String? education,
        String? profession,
        String? company,
        dynamic website,
        String? privacyLevel,
        bool? isVerified,
        dynamic verificationDocument,
        String? language,
        bool? isActive,
        String? whoCanSeePosts,
        String? whoCanSendFriendRequest,
        String? whoCanSendMessage,
        bool? showOnlineStatus,
        bool? showLastSeen,
        bool? showDob,
        bool? showLocation,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Profile(
            profileId: profileId ?? this.profileId,
            profileType: profileType ?? this.profileType,
            displayName: displayName ?? this.displayName,
            bio: bio ?? this.bio,
            profilePicture: profilePicture ?? this.profilePicture,
            coverImage: coverImage ?? this.coverImage,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
            placeOfBirth: placeOfBirth ?? this.placeOfBirth,
            gender: gender ?? this.gender,
            city: city ?? this.city,
            state: state ?? this.state,
            country: country ?? this.country,
            pincode: pincode ?? this.pincode,
            education: education ?? this.education,
            profession: profession ?? this.profession,
            company: company ?? this.company,
            website: website ?? this.website,
            privacyLevel: privacyLevel ?? this.privacyLevel,
            isVerified: isVerified ?? this.isVerified,
            verificationDocument: verificationDocument ?? this.verificationDocument,
            language: language ?? this.language,
            isActive: isActive ?? this.isActive,
            whoCanSeePosts: whoCanSeePosts ?? this.whoCanSeePosts,
            whoCanSendFriendRequest: whoCanSendFriendRequest ?? this.whoCanSendFriendRequest,
            whoCanSendMessage: whoCanSendMessage ?? this.whoCanSendMessage,
            showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
            showLastSeen: showLastSeen ?? this.showLastSeen,
            showDob: showDob ?? this.showDob,
            showLocation: showLocation ?? this.showLocation,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["ProfileID"],
        profileType: json["ProfileType"],
        displayName: json["DisplayName"],
        bio: json["Bio"],
        profilePicture: json["ProfilePicture"],
        coverImage: json["CoverImage"],
        dateOfBirth: json["DateOfBirth"] == null ? null : DateTime.parse(json["DateOfBirth"]),
        timeOfBirth: json["TimeOfBirth"],
        placeOfBirth: json["PlaceOfBirth"],
        gender: json["Gender"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        pincode: json["Pincode"],
        education: json["Education"],
        profession: json["Profession"],
        company: json["Company"],
        website: json["Website"],
        privacyLevel: json["PrivacyLevel"],
        isVerified: json["IsVerified"],
        verificationDocument: json["VerificationDocument"],
        language: json["Language"],
        isActive: json["IsActive"],
        whoCanSeePosts: json["WhoCanSeePosts"],
        whoCanSendFriendRequest: json["WhoCanSendFriendRequest"],
        whoCanSendMessage: json["WhoCanSendMessage"],
        showOnlineStatus: json["ShowOnlineStatus"],
        showLastSeen: json["ShowLastSeen"],
        showDob: json["ShowDOB"],
        showLocation: json["ShowLocation"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "ProfileID": profileId,
        "ProfileType": profileType,
        "DisplayName": displayName,
        "Bio": bio,
        "ProfilePicture": profilePicture,
        "CoverImage": coverImage,
        "DateOfBirth": dateOfBirth?.toIso8601String(),
        "TimeOfBirth": timeOfBirth,
        "PlaceOfBirth": placeOfBirth,
        "Gender": gender,
        "City": city,
        "State": state,
        "Country": country,
        "Pincode": pincode,
        "Education": education,
        "Profession": profession,
        "Company": company,
        "Website": website,
        "PrivacyLevel": privacyLevel,
        "IsVerified": isVerified,
        "VerificationDocument": verificationDocument,
        "Language": language,
        "IsActive": isActive,
        "WhoCanSeePosts": whoCanSeePosts,
        "WhoCanSendFriendRequest": whoCanSendFriendRequest,
        "WhoCanSendMessage": whoCanSendMessage,
        "ShowOnlineStatus": showOnlineStatus,
        "ShowLastSeen": showLastSeen,
        "ShowDOB": showDob,
        "ShowLocation": showLocation,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
    };
}

class User {
    final int? userId;
    final String? email;
    final String? phone;
    final bool? isEmailVerified;
    final bool? isPhoneVerified;
    final String? accountStatus;
    final dynamic twoFactorEnabled;
    final String? deviceToken;
    final DateTime? registrationDate;
    final dynamic lastLoginDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic dateOfBirth;
    final dynamic timeOfBirth;

    User({
        this.userId,
        this.email,
        this.phone,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.accountStatus,
        this.twoFactorEnabled,
        this.deviceToken,
        this.registrationDate,
        this.lastLoginDate,
        this.createdAt,
        this.updatedAt,
        this.dateOfBirth,
        this.timeOfBirth,
    });

    User copyWith({
        int? userId,
        String? email,
        String? phone,
        bool? isEmailVerified,
        bool? isPhoneVerified,
        String? accountStatus,
        dynamic twoFactorEnabled,
        String? deviceToken,
        DateTime? registrationDate,
        dynamic lastLoginDate,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic dateOfBirth,
        dynamic timeOfBirth,
    }) => 
        User(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            isEmailVerified: isEmailVerified ?? this.isEmailVerified,
            isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
            accountStatus: accountStatus ?? this.accountStatus,
            twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
            deviceToken: deviceToken ?? this.deviceToken,
            registrationDate: registrationDate ?? this.registrationDate,
            lastLoginDate: lastLoginDate ?? this.lastLoginDate,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        email: json["Email"],
        phone: json["Phone"],
        isEmailVerified: json["IsEmailVerified"],
        isPhoneVerified: json["IsPhoneVerified"],
        accountStatus: json["AccountStatus"],
        twoFactorEnabled: json["TwoFactorEnabled"],
        deviceToken: json["DeviceToken"],
        registrationDate: json["RegistrationDate"] == null ? null : DateTime.parse(json["RegistrationDate"]),
        lastLoginDate: json["LastLoginDate"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
        dateOfBirth: json["DateOfBirth"],
        timeOfBirth: json["TimeOfBirth"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Email": email,
        "Phone": phone,
        "IsEmailVerified": isEmailVerified,
        "IsPhoneVerified": isPhoneVerified,
        "AccountStatus": accountStatus,
        "TwoFactorEnabled": twoFactorEnabled,
        "DeviceToken": deviceToken,
        "RegistrationDate": registrationDate?.toIso8601String(),
        "LastLoginDate": lastLoginDate,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
        "DateOfBirth": dateOfBirth,
        "TimeOfBirth": timeOfBirth,
    };
}
