// To parse this JSON data, do
//
//     final friendRequestModel = friendRequestModelFromJson(jsonString);

import 'dart:convert';

FriendRequestModel friendRequestModelFromJson(String str) =>
    FriendRequestModel.fromJson(json.decode(str));

String friendRequestModelToJson(FriendRequestModel data) =>
    json.encode(data.toJson());

class FriendRequestModel {
  final bool? success;
  final String? message;
  final List<FriendRequest>? friendRequest;
  final Pagination? pagination;

  FriendRequestModel({
    this.success,
    this.message,
    this.friendRequest,
    this.pagination,
  });

  FriendRequestModel copyWith({
    bool? success,
    String? message,
    List<FriendRequest>? friendRequest,
    Pagination? pagination,
  }) => FriendRequestModel(
    success: success ?? this.success,
    message: message ?? this.message,
    friendRequest: friendRequest ?? this.friendRequest,
    pagination: pagination ?? this.pagination,
  );

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) =>
      FriendRequestModel(
        success: json["success"],
        message: json["message"],
        friendRequest:
            json["data"] == null
                ? []
                : List<FriendRequest>.from(
                  json["data"]!.map((x) => FriendRequest.fromJson(x)),
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
        friendRequest == null
            ? []
            : List<dynamic>.from(friendRequest!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class FriendRequest {
  final int? friendId;
  final String? profileType;
  final int? senderUserId;
  final int? senderProfileId;
  final int? receiverUserId;
  final int? receiverProfileId;
  final String? myRole;
  final String? displayName;
  final String? profilePicture;
  final String? gender;
  final String? city;
  final String? state;
  final String? country;
  final String? status;
  final DateTime? requestDate;
  final int? totalRecords;
  final bool? confirmRequestLoader;
  final bool? cancelRequest;

  FriendRequest({
    this.friendId,
    this.profileType,
    this.senderUserId,
    this.senderProfileId,
    this.receiverUserId,
    this.receiverProfileId,
    this.myRole,
    this.displayName,
    this.profilePicture,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.status,
    this.requestDate,
    this.totalRecords,
    this.confirmRequestLoader = false,
    this.cancelRequest = false,
  });

  FriendRequest copyWith({
    int? friendId,
    String? profileType,
    int? senderUserId,
    int? senderProfileId,
    int? receiverUserId,
    int? receiverProfileId,
    String? myRole,
    String? displayName,
    String? profilePicture,
    String? gender,
    String? city,
    String? state,
    String? country,
    String? status,
    DateTime? requestDate,
    int? totalRecords,
    bool? confirmRequestLoader,
    bool? cancelRequest,
  }) => FriendRequest(
    friendId: friendId ?? this.friendId,
    profileType: profileType ?? this.profileType,
    senderUserId: senderUserId ?? this.senderUserId,
    senderProfileId: senderProfileId ?? this.senderProfileId,
    receiverUserId: receiverUserId ?? this.receiverUserId,
    receiverProfileId: receiverProfileId ?? this.receiverProfileId,
    myRole: myRole ?? this.myRole,
    displayName: displayName ?? this.displayName,
    profilePicture: profilePicture ?? this.profilePicture,
    gender: gender ?? this.gender,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    status: status ?? this.status,
    requestDate: requestDate ?? this.requestDate,
    totalRecords: totalRecords ?? this.totalRecords,
    confirmRequestLoader: confirmRequestLoader ?? this.confirmRequestLoader,
    cancelRequest: cancelRequest ?? this.cancelRequest,
  );

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    friendId: json["FriendID"],
    profileType: json["ProfileType"],
    senderUserId: json["SenderUserID"],
    senderProfileId: json["SenderProfileID"],
    receiverUserId: json["ReceiverUserID"],
    receiverProfileId: json["ReceiverProfileID"],
    myRole: json["MyRole"],
    displayName: json["DisplayName"],
    profilePicture: json["ProfilePicture"],
    gender: json["Gender"],
    city: json["City"],
    state: json["State"],
    country: json["Country"],
    status: json["Status"],
    requestDate:
        json["RequestDate"] == null
            ? null
            : DateTime.parse(json["RequestDate"]),
    totalRecords: json["TotalRecords"],
  );

  Map<String, dynamic> toJson() => {
    "FriendID": friendId,
    "ProfileType": profileType,
    "SenderUserID": senderUserId,
    "SenderProfileID": senderProfileId,
    "ReceiverUserID": receiverUserId,
    "ReceiverProfileID": receiverProfileId,
    "MyRole": myRole,
    "DisplayName": displayName,
    "ProfilePicture": profilePicture,
    "Gender": gender,
    "City": city,
    "State": state,
    "Country": country,
    "Status": status,
    "RequestDate": requestDate?.toIso8601String(),
    "TotalRecords": totalRecords,
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
