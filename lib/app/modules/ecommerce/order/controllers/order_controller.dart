import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/my_order_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class OrderController extends GetxController {
  Rxn<MyOrderModel> myOrderModel = Rxn<MyOrderModel>();
  var isLoading = false.obs;
  Future<void> fetchOrder() async {
    isLoading.value = true;
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(
        api: "${EndPoint.ecommerceOrder}?customerId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        myOrderModel.value = myOrderModelFromJson(json.encode(res.data));

        log("Order ${myOrderModel.value}");
      } else {
        LoggerUtils.error("Order Failed : ${json.encode(res?.data)}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchOrder();
    super.onInit();
  }
}
