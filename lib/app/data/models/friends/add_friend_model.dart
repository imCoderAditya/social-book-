// To parse this JSON data, do
//
//     final addFriendsModel = addFriendsModelFromJson(jsonString);

import 'dart:convert';

AddFriendsModel addFriendsModelFromJson(String str) =>
    AddFriendsModel.fromJson(json.decode(str));

String addFriendsModelToJson(AddFriendsModel data) =>
    json.encode(data.toJson());

class AddFriendsModel {
  final bool? success;
  final String? message;
  final List<AddFriends>? addFriends;
  final Pagination? pagination;

  AddFriendsModel({
    this.success,
    this.message,
    this.addFriends,
    this.pagination,
  });

  AddFriendsModel copyWith({
    bool? success,
    String? message,
    List<AddFriends>? addFriends,
    Pagination? pagination,
  }) => AddFriendsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    addFriends: addFriends ?? this.addFriends,
    pagination: pagination ?? this.pagination,
  );

  factory AddFriendsModel.fromJson(Map<String, dynamic> json) =>
      AddFriendsModel(
        success: json["success"],
        message: json["message"],
        addFriends:
            json["data"] == null
                ? []
                : List<AddFriends>.from(
                  json["data"]!.map((x) => AddFriends.fromJson(x)),
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
        addFriends == null
            ? []
            : List<dynamic>.from(addFriends!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class AddFriends {
  final int? rowNum;
  final int? profileId;
  final int? userId;
  final String? displayName;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? profileType;
  final String? profilePicture;
  final String? coverImage;
  final bool? isVerified;
  final String? bio;
  final String? profession;
  final String? company;
  final String? relationshipStatus;
  final bool? isSendRequest;
  final bool? sendRequestLoader;


  AddFriends({
    this.rowNum,
    this.profileId,
    this.userId,
    this.displayName,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.profileType,
    this.profilePicture,
    this.coverImage,
    this.isVerified,
    this.bio,
    this.profession,
    this.company,
    this.relationshipStatus,
    this.isSendRequest = false,
    this.sendRequestLoader = false,

  });

  AddFriends copyWith({
    int? rowNum,
    int? profileId,
    int? userId,
    String? displayName,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? profileType,
    String? profilePicture,
    String? coverImage,
    bool? isVerified,
    String? bio,
    String? profession,
    String? company,
    String? relationshipStatus,
    bool? isSendRequest,
    bool? sendRequestLoader,
   
  }) => AddFriends(
    rowNum: rowNum ?? this.rowNum,
    profileId: profileId ?? this.profileId,
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    pincode: pincode ?? this.pincode,
    profileType: profileType ?? this.profileType,
    profilePicture: profilePicture ?? this.profilePicture,
    coverImage: coverImage ?? this.coverImage,
    isVerified: isVerified ?? this.isVerified,
    bio: bio ?? this.bio,
    profession: profession ?? this.profession,
    company: company ?? this.company,
    relationshipStatus: relationshipStatus ?? this.relationshipStatus,
    isSendRequest: isSendRequest ?? this.isSendRequest,
    sendRequestLoader: sendRequestLoader ?? this.sendRequestLoader,
   
  );

  factory AddFriends.fromJson(Map<String, dynamic> json) => AddFriends(
    rowNum: json["RowNum"],
    profileId: json["ProfileID"],
    userId: json["UserID"],
    displayName: json["DisplayName"],
    city: json["City"],
    state: json["State"],
    country: json["Country"],
    pincode: json["Pincode"],
    profileType: json["ProfileType"],
    profilePicture: json["ProfilePicture"],
    coverImage: json["CoverImage"],
    isVerified: json["IsVerified"],
    bio: json["Bio"],
    profession: json["Profession"],
    company: json["Company"],
    relationshipStatus: json["RelationshipStatus"],
  );

  Map<String, dynamic> toJson() => {
    "RowNum": rowNum,
    "ProfileID": profileId,
    "UserID": userId,
    "DisplayName": displayName,
    "City": city,
    "State": state,
    "Country": country,
    "Pincode": pincode,
    "ProfileType": profileType,
    "ProfilePicture": profilePicture,
    "CoverImage": coverImage,
    "IsVerified": isVerified,
    "Bio": bio,
    "Profession": profession,
    "Company": company,
    "RelationshipStatus": relationshipStatus,
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
