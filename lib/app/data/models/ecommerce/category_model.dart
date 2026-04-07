// To parse this JSON  categories, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel categories) =>
    json.encode(categories.toJson());

class CategoryModel {
  final bool? success;
  final int? userId;
  final Pagination? pagination;
  final List<Category>? categories;

  CategoryModel({this.success, this.userId, this.pagination, this.categories});

  CategoryModel copyWith({
    bool? success,
    int? userId,
    Pagination? pagination,
    List<Category>? categories,
  }) => CategoryModel(
    success: success ?? this.success,
    userId: userId ?? this.userId,
    pagination: pagination ?? this.pagination,
    categories: categories ?? this.categories,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    success: json["success"],
    userId: json["userId"],
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
    categories:
        json["data"] == null
            ? []
            : List<Category>.from(
              json["data"]!.map((x) => Category.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "userId": userId,
    "pagination": pagination?.toJson(),
    "data":
        categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class Category {
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final DateTime? createdDate;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.createdDate,
  });

  Category copyWith({
    int? categoryId,
    String? categoryName,
    String? categoryImage,
    DateTime? createdDate,
  }) => Category(
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    categoryImage: categoryImage ?? this.categoryImage,
    createdDate: createdDate ?? this.createdDate,
  );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    categoryImage: json["categoryImage"],
    createdDate:
        json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
    "categoryImage": categoryImage,
    "createdDate": createdDate?.toIso8601String(),
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
