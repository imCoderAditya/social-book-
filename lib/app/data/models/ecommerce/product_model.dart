// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final bool? success;
  final int? userId;
  final Pagination? pagination;
  final List<ProductData>? productData;

  ProductModel({this.success, this.userId, this.pagination, this.productData});

  ProductModel copyWith({
    bool? success,
    int? userId,
    Pagination? pagination,
    List<ProductData>? productData,
  }) => ProductModel(
    success: success ?? this.success,
    userId: userId ?? this.userId,
    pagination: pagination ?? this.pagination,
    productData: productData ?? this.productData,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    success: json["success"],
    userId: json["userId"],
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
    productData:
        json["data"] == null
            ? []
            : List<ProductData>.from(
              json["data"]!.map((x) => ProductData.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "userId": userId,
    "pagination": pagination?.toJson(),
    "data":
        productData == null
            ? []
            : List<dynamic>.from(productData!.map((x) => x.toJson())),
  };
}

class ProductData {
  final int? productId;
  final String? productName;
  final String? description;
  final String? shortDescription;
  final int? categoryId;
  final String? categoryName;
  final double? mrp;
  final double? sellingPrice;
  final int? inStock;
  final double? height;
  final double? width;
  final double? length;
  final double? weight;
  final double? shippingCharges;
  final DateTime? createdDate;
  final String? image;
  final List<Variant>? variants;

  ProductData({
    this.productId,
    this.productName,
    this.description,
    this.shortDescription,
    this.categoryId,
    this.categoryName,
    this.mrp,
    this.sellingPrice,
    this.inStock,
    this.height,
    this.width,
    this.length,
    this.weight,
    this.shippingCharges,
    this.createdDate,
    this.image,
    this.variants,
  });

  ProductData copyWith({
    int? productId,
    String? productName,
    String? description,
    String? shortDescription,
    int? categoryId,
    String? categoryName,
    double? mrp,
    double? sellingPrice,
    int? inStock,
    double? height,
    double? width,
    double? length,
    double? weight,
    double? shippingCharges,
    DateTime? createdDate,
    String? image,
    List<Variant>? variants,
  }) => ProductData(
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    description: description ?? this.description,
    shortDescription: shortDescription ?? this.shortDescription,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    mrp: mrp ?? this.mrp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    inStock: inStock ?? this.inStock,
    height: height ?? this.height,
    width: width ?? this.width,
    length: length ?? this.length,
    weight: weight ?? this.weight,
    shippingCharges: shippingCharges ?? this.shippingCharges,
    createdDate: createdDate ?? this.createdDate,
    image: image ?? this.image,
    variants: variants ?? this.variants,
  );

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    productId: json["productId"],
    productName: json["productName"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    mrp: json["mrp"],
    sellingPrice: json["sellingPrice"],
    inStock: json["inStock"],
    height: json["height"],
    width: json["width"],
    length: json["length"],
    weight: json["weight"],
    shippingCharges: json["shippingCharges"],
    createdDate:
        json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
    image: json["image"],
    variants:
        json["variants"] == null
            ? []
            : List<Variant>.from(
              json["variants"]!.map((x) => Variant.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "description": description,
    "shortDescription": shortDescription,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "mrp": mrp,
    "sellingPrice": sellingPrice,
    "inStock": inStock,
    "height": height,
    "width": width,
    "length": length,
    "weight": weight,
    "shippingCharges": shippingCharges,
    "createdDate": createdDate?.toIso8601String(),
    "image": image,
    "variants":
        variants == null
            ? []
            : List<dynamic>.from(variants!.map((x) => x.toJson())),
  };
}

class Variant {
  final String? sizeId;
  final int? price;
  final int? stock;
  final List<Color>? colors;

  Variant({this.sizeId, this.price, this.stock, this.colors});

  Variant copyWith({
    String? sizeId,
    int? price,
    int? stock,
    List<Color>? colors,
  }) => Variant(
    sizeId: sizeId ?? this.sizeId,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    colors: colors ?? this.colors,
  );

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    sizeId: json["sizeId"],
    price: json["price"],
    stock: json["stock"],
    colors:
        json["colors"] == null
            ? []
            : List<Color>.from(json["colors"]!.map((x) => Color.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sizeId": sizeId,
    "price": price,
    "stock": stock,
    "colors":
        colors == null
            ? []
            : List<dynamic>.from(colors!.map((x) => x.toJson())),
  };
}

class Color {
  final String? colorId;
  final List<String>? images;

  Color({this.colorId, this.images});

  Color copyWith({String? colorId, List<String>? images}) =>
      Color(colorId: colorId ?? this.colorId, images: images ?? this.images);

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    colorId: json["colorId"],
    images:
        json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "colorId": colorId,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
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
