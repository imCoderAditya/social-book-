// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  final bool? success;
  final String? userId;
  final int? totalItems;
  final Summary? summary;
  final List<CartData>? cartData;

  CartModel({
    this.success,
    this.userId,
    this.totalItems,
    this.summary,
    this.cartData,
  });

  CartModel copyWith({
    bool? success,
    String? userId,
    int? totalItems,
    Summary? summary,
    List<CartData>? cartData,
  }) => CartModel(
    success: success ?? this.success,
    userId: userId ?? this.userId,
    totalItems: totalItems ?? this.totalItems,
    summary: summary ?? this.summary,
    cartData: cartData ?? this.cartData,
  );

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    success: json["success"],
    userId: json["userId"],
    totalItems: json["totalItems"],
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    cartData:
        json["data"] == null
            ? []
            : List<CartData>.from(
              json["data"]!.map((x) => CartData.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "userId": userId,
    "totalItems": totalItems,
    "summary": summary?.toJson(),
    "data":
        cartData == null ? [] : List<dynamic>.from(cartData!.map((x) => x.toJson())),
  };
}

class CartData {
  final int? id;
  final int? productId;
  final int? variantId;
  final String? productName;
  final int? qty;
  final String? size;
  final String? color;
  final String? productImage;
  final double? unitPrice;
  final double? totalSell;

  CartData({
    this.id,
    this.productId,
    this.variantId,
    this.productName,
    this.qty,
    this.size,
    this.color,
    this.productImage,
    this.unitPrice,
    this.totalSell,
  });

  CartData copyWith({
    int? id,
    int? productId,
    int? variantId,
    String? productName,
    int? qty,
    String? size,
    String? color,
    String? productImage,
    double? unitPrice,
    double? totalSell,
  }) => CartData(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    variantId: variantId ?? this.variantId,
    productName: productName ?? this.productName,
    qty: qty ?? this.qty,
    size: size ?? this.size,
    color: color ?? this.color,
    productImage: productImage ?? this.productImage,
    unitPrice: unitPrice ?? this.unitPrice,
    totalSell: totalSell ?? this.totalSell,
  );

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["id"],
    productId: json["product_id"],
    variantId: json["variantId"],
    productName: json["product_name"],
    qty: json["qty"],
    size: json["Size"],
    color: json["Color"],
    productImage: json["ProductImage"],
    unitPrice: json["UnitPrice"]?.toDouble(),
    totalSell: json["total_sell"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "variantId": variantId,
    "product_name": productName,
    "qty": qty,
    "Size": size,
    "Color": color,
    "ProductImage": productImage,
    "UnitPrice": unitPrice,
    "total_sell": totalSell,
  };
}

class Summary {
  final double? subTotal;
  final double? shippingCharge;
  final double? grandTotal;

  Summary({this.subTotal, this.shippingCharge, this.grandTotal});

  Summary copyWith({
    double? subTotal,
    double? shippingCharge,
    double? grandTotal,
  }) => Summary(
    subTotal: subTotal ?? this.subTotal,
    shippingCharge: shippingCharge ?? this.shippingCharge,
    grandTotal: grandTotal ?? this.grandTotal,
  );

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    subTotal: json["subTotal"]?.toDouble(),
    shippingCharge: json["shippingCharge"]?.toDouble(),
    grandTotal: json["grandTotal"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "subTotal": subTotal,
    "shippingCharge": shippingCharge,
    "grandTotal": grandTotal,
  };
}
