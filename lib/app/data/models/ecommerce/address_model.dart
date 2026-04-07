// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
    final bool? success;
    final int? total;
    final List<AddressData>? addressData;

    AddressModel({
        this.success,
        this.total,
        this.addressData,
    });

    AddressModel copyWith({
        bool? success,
        int? total,
        List<AddressData>? addressData,
    }) => 
        AddressModel(
            success: success ?? this.success,
            total: total ?? this.total,
            addressData: addressData ?? this.addressData,
        );

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        success: json["success"],
        total: json["total"],
        addressData: json["data"] == null ? [] : List<AddressData>.from(json["data"]!.map((x) => AddressData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total": total,
        "data": addressData == null ? [] : List<dynamic>.from(addressData!.map((x) => x.toJson())),
    };
}

class AddressData {
    final int? addressId;
    final String? customerId;
    final String? fullName;
    final String? mobileNo;
    final String? email;
    final String? addressLine1;
    final String? city;
    final String? state;
    final String? country;
    final String? pincode;
    final String? landmark;
    final String? houseandFlatNo;
    final bool? isDelete;
    final DateTime? createdDate;

    AddressData({
        this.addressId,
        this.customerId,
        this.fullName,
        this.mobileNo,
        this.email,
        this.addressLine1,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.landmark,
        this.houseandFlatNo,
        this.isDelete,
        this.createdDate,
    });

    AddressData copyWith({
        int? addressId,
        String? customerId,
        String? fullName,
        String? mobileNo,
        String? email,
        String? addressLine1,
        String? city,
        String? state,
        String? country,
        String? pincode,
        String? landmark,
        String? houseandFlatNo,
        bool? isDelete,
        DateTime? createdDate,
    }) => 
        AddressData(
            addressId: addressId ?? this.addressId,
            customerId: customerId ?? this.customerId,
            fullName: fullName ?? this.fullName,
            mobileNo: mobileNo ?? this.mobileNo,
            email: email ?? this.email,
            addressLine1: addressLine1 ?? this.addressLine1,
            city: city ?? this.city,
            state: state ?? this.state,
            country: country ?? this.country,
            pincode: pincode ?? this.pincode,
            landmark: landmark ?? this.landmark,
            houseandFlatNo: houseandFlatNo ?? this.houseandFlatNo,
            isDelete: isDelete ?? this.isDelete,
            createdDate: createdDate ?? this.createdDate,
        );

    factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        addressId: json["address_id"],
        customerId: json["customer_id"],
        fullName: json["full_name"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        addressLine1: json["address_line1"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["Pincode"],
        landmark: json["landmark"],
        houseandFlatNo: json["HouseandFlat_No"],
        isDelete: json["is_delete"],
        createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    );

    Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "customer_id": customerId,
        "full_name": fullName,
        "mobile_no": mobileNo,
        "email": email,
        "address_line1": addressLine1,
        "city": city,
        "state": state,
        "country": country,
        "Pincode": pincode,
        "landmark": landmark,
        "HouseandFlat_No": houseandFlatNo,
        "is_delete": isDelete,
        "created_date": createdDate?.toIso8601String(),
    };
}
