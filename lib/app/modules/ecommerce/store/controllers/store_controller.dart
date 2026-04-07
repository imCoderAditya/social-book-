// import 'dart:convert';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/category_model.dart';
import 'package:social_book/app/data/models/ecommerce/product_model.dart';

class StoreController extends GetxController {
  // StoreController ke andar
final TextEditingController searchEditController = TextEditingController();
  // --- Category State ---
  RxBool isCategoryLoading = false.obs;
  RxBool isCategoryLoadingMore = false.obs;
  final ScrollController scrollCategoryController = ScrollController();
  final Rxn<CategoryModel> categoryModel = Rxn<CategoryModel>();
  final RxList<Category> categoriesList = <Category>[].obs;
  final currentCategoryPage = 1.obs;

  // --- Product State ---
  RxBool isProductLoading = false.obs;
  RxBool isProductLoadingMore = false.obs;
  final ScrollController scrollProductController = ScrollController();
  final Rxn<ProductModel> productModel = Rxn<ProductModel>();
  final RxList<ProductData> productList = <ProductData>[].obs;
  final currentProductPage = 1.obs;
  
  final searchQuery = ''.obs;
  final Rxn<int> selectedCategoryId = Rxn<int>();

  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();

    // 1. Debouncing for Search: Jab user type karna band karega tabhi call jayegi
    debounce(searchQuery, (_) => _performSearch(), time: const Duration(milliseconds: 500));

    // 2. Initial Data Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCategory();
      // Note: getCategory() ke end mein pehli category ke products load ho rahe hain
    });

    // 3. Scroll Listeners
    scrollCategoryController.addListener(_categoryScroll);
    scrollProductController.addListener(_productScroll);
  }

  // --- Category Logic ---
  Future<void> getCategory({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isCategoryLoadingMore.value = true;
    } else {
      isCategoryLoading.value = true;
    }

    try {

      print("${EndPoint.ecommerceCategories}?pageNumber=${currentCategoryPage.value}&pageSize=$pageSize");
      final res = await BaseClient.get(
        api: "${EndPoint.ecommerceCategories}?pageNumber=${currentCategoryPage.value}&pageSize=$pageSize",
      );

      if (res != null && res.statusCode == 200) {
        categoryModel.value = categoryModelFromJson(json.encode(res.data));
        final newCategories = categoryModel.value?.categories ?? [];

        if (isLoadMore) {
          categoriesList.addAll(newCategories);
        } else {
          categoriesList.assignAll(newCategories);
          // Auto-load products for first category if nothing selected
          if (categoriesList.isNotEmpty && selectedCategoryId.value == null) {
            filterByCategory(categoriesList.first.categoryId);
          }
        }
      }
    } catch (e) {
      LoggerUtils.error("Category Error: $e");
    } finally {
      isCategoryLoading.value = false;
      isCategoryLoadingMore.value = false;
    }
  }

  // --- Product Logic ---
  Future<void> getProducts({
    bool isLoadMore = false,
    int? categoryId,
    String? search,
  }) async {
    if (isLoadMore) {
      if (isProductLoadingMore.value) return; // Guard clause
      isProductLoadingMore.value = true;
    } else {
      isProductLoading.value = true;
    }

    try {
      String apiUrl = "${EndPoint.ecommerceProducts}?pageNumber=${currentProductPage.value}&pageSize=$pageSize";
      if (search != null && search.isNotEmpty) apiUrl += "&search=$search";
      if (categoryId != null) apiUrl += "&categoryId=$categoryId";

      final res = await BaseClient.get(api: apiUrl);

      if (res != null && res.statusCode == 200) {
        productModel.value = productModelFromJson(json.encode(res.data));
        final newProducts = productModel.value?.productData ?? [];

        if (isLoadMore) {
          productList.addAll(newProducts);
        } else {
          productList.assignAll(newProducts);
        }
      }
    } catch (e) {
      LoggerUtils.error("Product Error: $e");
    } finally {
      isProductLoading.value = false;
      isProductLoadingMore.value = false;
    }
  }

  // --- Search & Filter Actions ---
  void _performSearch() {
    currentProductPage.value = 1;
    getProducts(search: searchQuery.value, categoryId: selectedCategoryId.value);
  }

  // UI se call karein: controller.searchQuery.value = val;
  void updateSearch(String val) {
    searchQuery.value = val;
  }

  Future<void> filterByCategory(int? categoryId) async {
    selectedCategoryId.value = categoryId;
    currentProductPage.value = 1;
    await getProducts(categoryId: categoryId, search: searchQuery.value);
  }

  // --- Pagination Helpers ---
  void _categoryScroll() {
    if (scrollCategoryController.position.pixels >= scrollCategoryController.position.maxScrollExtent - 200) {
      final totalPages = categoryModel.value?.pagination?.totalPages ?? 0;
      if (currentCategoryPage.value < totalPages && !isCategoryLoadingMore.value) {
        currentCategoryPage.value++;
        getCategory(isLoadMore: true);
      }
    }
  }

  void _productScroll() {
    if (scrollProductController.position.pixels >= scrollProductController.position.maxScrollExtent - 200) {
      final totalPages = productModel.value?.pagination?.totalPages ?? 0;
      if (currentProductPage.value < totalPages && !isProductLoadingMore.value) {
        currentProductPage.value++;
        getProducts(
          isLoadMore: true,
          categoryId: selectedCategoryId.value,
          search: searchQuery.value,
        );
      }
    }
  }

  @override
  void onClose() {
    scrollCategoryController.dispose();
    scrollProductController.dispose();
    super.onClose();
  }
}
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:social_book/app/core/utils/logger_utils.dart';
// import 'package:social_book/app/data/baseclient/base_client.dart';
// import 'package:social_book/app/data/endpoint/end_pont.dart';
// import 'package:social_book/app/data/models/ecommerce/category_model.dart';
// import 'package:social_book/app/data/models/ecommerce/product_model.dart';

// class StoreController extends GetxController {
//   // Category related
//   RxBool isCategoryLoading = false.obs;
//   RxBool isCategoryLoadingMore = false.obs;
//   ScrollController scrollCategoryController = ScrollController();
//   Rxn<CategoryModel> categoryModel = Rxn<CategoryModel>();
//   RxList<Category> categoriesList = RxList<Category>([]);
//   var currentCategoryPage = 1.obs;

//   // Product related
//   RxBool isProductLoading = false.obs;
//   RxBool isProductLoadingMore = false.obs;
//   ScrollController scrollProductController = ScrollController();
//   Rxn<ProductModel> productModel = Rxn<ProductModel>();
//   RxList<ProductData> productList = RxList<ProductData>([]);
//   var currentProductPage = 1.obs;
//   RxString searchQuery = ''.obs;
//   Rxn<int> selectedCategoryId = Rxn<int>();

//   final int pageSize = 20;

//   Future<void> getCategory({bool isLoadMore = false}) async {
//     if (isLoadMore) {
//       isCategoryLoadingMore.value = true;
//     } else {
//       isCategoryLoading.value = true;
//     }

//     try {
//       final res = await BaseClient.get(
//         api:
//             "${EndPoint.ecommerceCategories}?pageNumber=${currentCategoryPage.value}&pageSize=$pageSize",
//       );

//       if (res != null && res.statusCode == 200) {
//         LoggerUtils.debug("Category Response: ${json.encode(res.data)}");
//         categoryModel.value = categoryModelFromJson(json.encode(res.data));

//         if (isLoadMore) {
//           categoriesList.addAll(categoryModel.value?.categories ?? []);
//         } else {
//           categoriesList.value = categoryModel.value?.categories ?? [];
//           await getProducts(categoryId: categoriesList.firstOrNull?.categoryId);
//         }
//       } else {
//         LoggerUtils.error("Category error: ${json.encode(res?.data)}");
//       }
//     } catch (e) {
//       LoggerUtils.error("Category Error: $e");
//     } finally {
//       if (isLoadMore) {
//         isCategoryLoadingMore.value = false;
//       } else {
//         isCategoryLoading.value = false;
//       }
//     }
//   }

//   Future<void> _categoryScroll() async {
//     final totalPages = categoryModel.value?.pagination?.totalPages ?? 0;

//     if (scrollCategoryController.position.pixels >=
//             scrollCategoryController.position.maxScrollExtent - 200 &&
//         !isCategoryLoadingMore.value &&
//         currentCategoryPage.value < totalPages) {
//       _loadMoreCategories();
//     }
//   }

//   Future<void> _loadMoreCategories() async {
//     final totalPages = categoryModel.value?.pagination?.totalPages ?? 0;
//     final totalRecords = categoryModel.value?.pagination?.totalCount ?? 0;

//     if (currentCategoryPage.value < totalPages &&
//         !isCategoryLoadingMore.value &&
//         categoriesList.length < totalRecords) {
//       currentCategoryPage.value++;
//       debugPrint("Loading category page: ${currentCategoryPage.value}");
//       await getCategory(isLoadMore: true);
//     }
//   }

//   Future<void> refreshCategories() async {
//     currentCategoryPage.value = 1;
//     categoriesList.clear();
//     await getCategory();
//   }

//   Future<void> getProducts({
//     bool isLoadMore = false,
//     int? categoryId,
//     String? search,
//   }) async {
//     if (isLoadMore) {
//       isProductLoadingMore.value = true;
//     } else {
//       isProductLoading.value = true;
//     }

//     try {
//       String apiUrl =
//           "${EndPoint.ecommerceProducts}?pageNumber=${currentProductPage.value}&pageSize=$pageSize";

//       if (search != null && search.isNotEmpty) {
//         apiUrl += "&search=$search";
//       }

//       if (categoryId != null) {
//         apiUrl += "&categoryId=$categoryId";
//       }

//       final res = await BaseClient.get(api: apiUrl);

//       if (res != null && res.statusCode == 200) {
//         productModel.value = productModelFromJson(json.encode(res.data));
//         LoggerUtils.debug(
//           "Product Response: ${json.encode(productModel.value)}",
//         );
//         if (isLoadMore) {
//           productList.addAll(productModel.value?.productData ?? []);
//         } else {
//           productList.value = productModel.value?.productData ?? [];
//         }
//       } else {
//         LoggerUtils.error("Product error: ${json.encode(res?.data)}");
//       }
//     } catch (e) {
//       LoggerUtils.error("Product Error: $e");
//     } finally {
//       if (isLoadMore) {
//         isProductLoadingMore.value = false;
//       } else {
//         isProductLoading.value = false;
//       }
//     }
//   }

//   Future<void> _productScroll() async {
//     final totalPages = productModel.value?.pagination?.totalPages ?? 0;

//     if (scrollProductController.position.pixels >=
//             scrollProductController.position.maxScrollExtent - 200 &&
//         !isProductLoadingMore.value &&
//         currentProductPage.value < totalPages) {
//       _loadMoreProducts();
//     }
//   }

//   Future<void> _loadMoreProducts() async {
//     final totalPages = productModel.value?.pagination?.totalPages ?? 0;
//     final totalRecords = productModel.value?.pagination?.totalCount ?? 0;

//     if (currentProductPage.value < totalPages &&
//         !isProductLoadingMore.value &&
//         productList.length < totalRecords) {
//       currentProductPage.value++;
//       debugPrint("Loading product page: ${currentProductPage.value}");
//       await getProducts(
//         isLoadMore: true,
//         categoryId: selectedCategoryId.value,
//         search: searchQuery.value,
//       );
//     }
//   }

//   Future<void> refreshProducts() async {
//     currentProductPage.value = 1;
//     productList.clear();
//     await getProducts(
//       categoryId: selectedCategoryId.value,
//       search: searchQuery.value,
//     );
//   }

//   Future<void> filterByCategory(int? categoryId) async {
//     selectedCategoryId.value = categoryId;
//     currentProductPage.value = 1;
//     productList.clear();
//     await getProducts(categoryId: categoryId, search: searchQuery.value);
//   }

//   Future<void> searchProducts(String query) async {
//     searchQuery.value = query;
//     currentProductPage.value = 1;
//     productList.clear();
//     await getProducts(search: query, categoryId: selectedCategoryId.value);
//   }

//   Future<void> clearFilters() async {
//     selectedCategoryId.value = null;
//     searchQuery.value = '';
//     currentProductPage.value = 1;
//     productList.clear();
//     await getProducts();
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await getCategory();
//       await getProducts();
//     });

//     scrollCategoryController.addListener(_categoryScroll);
//     scrollProductController.addListener(_productScroll);
//   }

//   @override
//   void onClose() {
//     scrollCategoryController.removeListener(_categoryScroll);
//     scrollCategoryController.dispose();
//     scrollProductController.removeListener(_productScroll);
//     scrollProductController.dispose();
//     super.onClose();
//   }
// }