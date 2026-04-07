// To parse this JSON data, do
//
//     final friendModel = friendModelFromJson(jsonString);

import 'dart:convert';

FriendModel friendModelFromJson(String str) =>
    FriendModel.fromJson(json.decode(str));

String friendModelToJson(FriendModel data) => json.encode(data.toJson());

class FriendModel {
  final bool? success;
  final String? message;
  final List<Fronds>? data;
  final Pagination? pagination;

  FriendModel({this.success, this.message, this.data, this.pagination});

  FriendModel copyWith({
    bool? success,
    String? message,
    List<Fronds>? data,
    Pagination? pagination,
  }) => FriendModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    pagination: pagination ?? this.pagination,
  );

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
    success: json["success"],
    message: json["message"],
    data:
        json["data"] == null
            ? []
            : List<Fronds>.from(json["data"]!.map((x) => Fronds.fromJson(x))),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Fronds {
  final int? friendId;
  final int? userId;
  final int? profileId;
  final String? displayName;
  final String? profileType;
  final String? profilePicture;
  final String? gender;
  final String? city;
  final String? state;
  final String? country;
  final DateTime? requestDate;
  final DateTime? responseDate;
  final int? totalRecords;

  Fronds({
    this.friendId,
    this.userId,
    this.profileId,
    this.displayName,
    this.profileType,
    this.profilePicture,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.requestDate,
    this.responseDate,
    this.totalRecords,
  });

  Fronds copyWith({
    int? friendId,
    int? userId,
    int? profileId,
    String? displayName,
    String? profileType,
    String? profilePicture,
    String? gender,
    String? city,
    String? state,
    String? country,
    DateTime? requestDate,
    DateTime? responseDate,
    int? totalRecords,
  }) => Fronds(
    friendId: friendId ?? this.friendId,
    userId: userId ?? this.userId,
    profileId: profileId ?? this.profileId,
    displayName: displayName ?? this.displayName,
    profileType: profileType ?? this.profileType,
    profilePicture: profilePicture ?? this.profilePicture,
    gender: gender ?? this.gender,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    requestDate: requestDate ?? this.requestDate,
    responseDate: responseDate ?? this.responseDate,
    totalRecords: totalRecords ?? this.totalRecords,
  );

  factory Fronds.fromJson(Map<String, dynamic> json) => Fronds(
    friendId: json["FriendID"],
    userId: json["UserID"],
    profileId: json["ProfileID"],
    displayName: json["DisplayName"],
    profileType: json["ProfileType"],
    profilePicture: json["ProfilePicture"],
    gender: json["Gender"],
    city: json["City"],
    state: json["State"],
    country: json["Country"],
    requestDate:
        json["RequestDate"] == null
            ? null
            : DateTime.parse(json["RequestDate"]),
    responseDate:
        json["ResponseDate"] == null
            ? null
            : DateTime.parse(json["ResponseDate"]),
    totalRecords: json["TotalRecords"],
  );

  Map<String, dynamic> toJson() => {
    "FriendID": friendId,
    "UserID": userId,
    "ProfileID": profileId,
    "DisplayName": displayName,
    "ProfileType": profileType,
    "ProfilePicture": profilePicture,
    "Gender": gender,
    "City": city,
    "State": state,
    "Country": country,
    "RequestDate": requestDate?.toIso8601String(),
    "ResponseDate": responseDate?.toIso8601String(),
    "TotalRecords": totalRecords,
  };
}

class Pagination {
  final int? pageNumber;
  final int? pageSize;
  final int? totalRecords;
  final int? totalPages;

  Pagination({
    this.pageNumber,
    this.pageSize,
    this.totalRecords,
    this.totalPages,
  });

  Pagination copyWith({
    int? pageNumber,
    int? pageSize,
    int? totalRecords,
    int? totalPages,
  }) => Pagination(
    pageNumber: pageNumber ?? this.pageNumber,
    pageSize: pageSize ?? this.pageSize,
    totalRecords: totalRecords ?? this.totalRecords,
    totalPages: totalPages ?? this.totalPages,
  );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
