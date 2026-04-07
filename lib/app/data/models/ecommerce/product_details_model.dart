// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) => ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) => json.encode(data.toJson());

class ProductDetailsModel {
    final bool? success;
    final int? userId;
    final ProductDetails? productDetails;

    ProductDetailsModel({
        this.success,
        this.userId,
        this.productDetails,
    });

    ProductDetailsModel copyWith({
        bool? success,
        int? userId,
        ProductDetails? data,
    }) => 
        ProductDetailsModel(
            success: success ?? this.success,
            userId: userId ?? this.userId,
            productDetails: data ?? productDetails,
        );

    factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
        success: json["success"],
        userId: json["userId"],
        productDetails: json["data"] == null ? null : ProductDetails.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "userId": userId,
        "data": productDetails?.toJson(),
    };
}

class ProductDetails {
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

    ProductDetails({
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

    ProductDetails copyWith({
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
    }) => 
        ProductDetails(
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

    factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        productId: json["productId"],
        productName: json["productName"],
        description: json["description"],
        shortDescription: json["shortDescription"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        mrp: json["mrp"]?.toDouble(),
        sellingPrice: json["sellingPrice"]?.toDouble(),
        inStock: json["inStock"],
        height: json["height"]?.toDouble(),
        width: json["width"]?.toDouble(),
        length: json["length"]?.toDouble(),
        weight: json["weight"]?.toDouble(),
        shippingCharges: json["shippingCharges"]?.toDouble(),
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        image: json["image"],
        variants: json["variants"] == null ? [] : List<Variant>.from(json["variants"]!.map((x) => Variant.fromJson(x))),
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
        "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x.toJson())),
    };
}

class Variant {
    final String? sizeId;
    final double? price;
    final int? stock;
    final List<Color>? colors;

    Variant({
        this.sizeId,
        this.price,
        this.stock,
        this.colors,
    });

    Variant copyWith({
        String? sizeId,
        double? price,
        int? stock,
        List<Color>? colors,
    }) => 
        Variant(
            sizeId: sizeId ?? this.sizeId,
            price: price ?? this.price,
            stock: stock ?? this.stock,
            colors: colors ?? this.colors,
        );

    factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        sizeId: json["sizeId"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        colors: json["colors"] == null ? [] : List<Color>.from(json["colors"]!.map((x) => Color.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "sizeId": sizeId,
        "price": price,
        "stock": stock,
        "colors": colors == null ? [] : List<dynamic>.from(colors!.map((x) => x.toJson())),
    };
}

class Color {
    final String? colorId;
    final List<String>? images;

    Color({
        this.colorId,
        this.images,
    });

    Color copyWith({
        String? colorId,
        List<String>? images,
    }) => 
        Color(
            colorId: colorId ?? this.colorId,
            images: images ?? this.images,
        );

    factory Color.fromJson(Map<String, dynamic> json) => Color(
        colorId: json["colorId"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "colorId": colorId,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    };
}
