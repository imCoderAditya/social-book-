// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    final bool? success;
    final UserProfileData? data;

    UserProfileModel({
        this.success,
        this.data,
    });

    UserProfileModel copyWith({
        bool? success,
        UserProfileData? data,
    }) => 
        UserProfileModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        success: json["success"],
        data: json["data"] == null ? null : UserProfileData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class UserProfileData {
    final int? profileId;
    final int? userId;
    final String? profileType;
    final String? displayName;
    final String? bio;
    final String? profilePictureUrl;
    final String? coverImageUrl;
    final String? dateOfBirth;
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
    final String? whoCanSeePosts;
    final String? whoCanSendFriendRequest;
    final String? whoCanSendMessage;
    final bool? showOnlineStatus;
    final bool? showLastSeen;
    final bool? showDob;
    final bool? showLocation;
    final dynamic hometown;
    final dynamic livingIn;
    final dynamic relationshipStatus;
    final dynamic motherTongue;
    final dynamic maritalStatus;
    final dynamic bloodGroup;
    final dynamic experienceYears;
    final dynamic workAt;
    final dynamic workLocation;
    final dynamic skills;
    final String? createdAt;
    final String? updatedAt;
    final List<String>? interests;

    UserProfileData({
        this.profileId,
        this.userId,
        this.profileType,
        this.displayName,
        this.bio,
        this.profilePictureUrl,
        this.coverImageUrl,
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
        this.whoCanSeePosts,
        this.whoCanSendFriendRequest,
        this.whoCanSendMessage,
        this.showOnlineStatus,
        this.showLastSeen,
        this.showDob,
        this.showLocation,
        this.hometown,
        this.livingIn,
        this.relationshipStatus,
        this.motherTongue,
        this.maritalStatus,
        this.bloodGroup,
        this.experienceYears,
        this.workAt,
        this.workLocation,
        this.skills,
        this.createdAt,
        this.updatedAt,
        this.interests,
    });

    UserProfileData copyWith({
        int? profileId,
        int? userId,
        String? profileType,
        String? displayName,
        String? bio,
        String? profilePictureUrl,
        String? coverImageUrl,
        String? dateOfBirth,
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
        String? whoCanSeePosts,
        String? whoCanSendFriendRequest,
        String? whoCanSendMessage,
        bool? showOnlineStatus,
        bool? showLastSeen,
        bool? showDob,
        bool? showLocation,
        dynamic hometown,
        dynamic livingIn,
        dynamic relationshipStatus,
        dynamic motherTongue,
        dynamic maritalStatus,
        dynamic bloodGroup,
        dynamic experienceYears,
        dynamic workAt,
        dynamic workLocation,
        dynamic skills,
        String? createdAt,
        String? updatedAt,
        List<String>? interests,
    }) => 
        UserProfileData(
            profileId: profileId ?? this.profileId,
            userId: userId ?? this.userId,
            profileType: profileType ?? this.profileType,
            displayName: displayName ?? this.displayName,
            bio: bio ?? this.bio,
            profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
            coverImageUrl: coverImageUrl ?? this.coverImageUrl,
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
            whoCanSeePosts: whoCanSeePosts ?? this.whoCanSeePosts,
            whoCanSendFriendRequest: whoCanSendFriendRequest ?? this.whoCanSendFriendRequest,
            whoCanSendMessage: whoCanSendMessage ?? this.whoCanSendMessage,
            showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
            showLastSeen: showLastSeen ?? this.showLastSeen,
            showDob: showDob ?? this.showDob,
            showLocation: showLocation ?? this.showLocation,
            hometown: hometown ?? this.hometown,
            livingIn: livingIn ?? this.livingIn,
            relationshipStatus: relationshipStatus ?? this.relationshipStatus,
            motherTongue: motherTongue ?? this.motherTongue,
            maritalStatus: maritalStatus ?? this.maritalStatus,
            bloodGroup: bloodGroup ?? this.bloodGroup,
            experienceYears: experienceYears ?? this.experienceYears,
            workAt: workAt ?? this.workAt,
            workLocation: workLocation ?? this.workLocation,
            skills: skills ?? this.skills,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            interests: interests ?? this.interests,
        );

    factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
        profileId: json["profileId"],
        userId: json["userId"],
        profileType: json["profileType"],
        displayName: json["displayName"],
        bio: json["bio"],
        profilePictureUrl: json["profilePictureUrl"],
        coverImageUrl: json["coverImageUrl"],
        dateOfBirth: json["dateOfBirth"],
        timeOfBirth: json["timeOfBirth"],
        placeOfBirth: json["placeOfBirth"],
        gender: json["gender"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        education: json["education"],
        profession: json["profession"],
        company: json["company"],
        website: json["website"],
        privacyLevel: json["privacyLevel"],
        isVerified: json["isVerified"],
        verificationDocument: json["verificationDocument"],
        language: json["language"],
        whoCanSeePosts: json["whoCanSeePosts"],
        whoCanSendFriendRequest: json["whoCanSendFriendRequest"],
        whoCanSendMessage: json["whoCanSendMessage"],
        showOnlineStatus: json["showOnlineStatus"],
        showLastSeen: json["showLastSeen"],
        showDob: json["showDOB"],
        showLocation: json["showLocation"],
        hometown: json["hometown"],
        livingIn: json["livingIn"],
        relationshipStatus: json["relationshipStatus"],
        motherTongue: json["motherTongue"],
        maritalStatus: json["maritalStatus"],
        bloodGroup: json["bloodGroup"],
        experienceYears: json["experienceYears"],
        workAt: json["workAt"],
        workLocation: json["workLocation"],
        skills: json["skills"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "userId": userId,
        "profileType": profileType,
        "displayName": displayName,
        "bio": bio,
        "profilePictureUrl": profilePictureUrl,
        "coverImageUrl": coverImageUrl,
        "dateOfBirth": dateOfBirth,
        "timeOfBirth": timeOfBirth,
        "placeOfBirth": placeOfBirth,
        "gender": gender,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "education": education,
        "profession": profession,
        "company": company,
        "website": website,
        "privacyLevel": privacyLevel,
        "isVerified": isVerified,
        "verificationDocument": verificationDocument,
        "language": language,
        "whoCanSeePosts": whoCanSeePosts,
        "whoCanSendFriendRequest": whoCanSendFriendRequest,
        "whoCanSendMessage": whoCanSendMessage,
        "showOnlineStatus": showOnlineStatus,
        "showLastSeen": showLastSeen,
        "showDOB": showDob,
        "showLocation": showLocation,
        "hometown": hometown,
        "livingIn": livingIn,
        "relationshipStatus": relationshipStatus,
        "motherTongue": motherTongue,
        "maritalStatus": maritalStatus,
        "bloodGroup": bloodGroup,
        "experienceYears": experienceYears,
        "workAt": workAt,
        "workLocation": workLocation,
        "skills": skills,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
    };
}
