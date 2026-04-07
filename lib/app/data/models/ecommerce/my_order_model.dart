// To parse this JSON data, do
//
//     final myOrderModel = myOrderModelFromJson(jsonString);

import 'dart:convert';

MyOrderModel myOrderModelFromJson(String str) => MyOrderModel.fromJson(json.decode(str));

String myOrderModelToJson(MyOrderModel data) => json.encode(data.toJson());

class MyOrderModel {
    final bool? success;
    final String? customerId;
    final int? totalOrders;
    final List<OderData>? oderData;

    MyOrderModel({
        this.success,
        this.customerId,
        this.totalOrders,
        this.oderData,
    });

    MyOrderModel copyWith({
        bool? success,
        String? customerId,
        int? totalOrders,
        List<OderData>? oderData,
    }) => 
        MyOrderModel(
            success: success ?? this.success,
            customerId: customerId ?? this.customerId,
            totalOrders: totalOrders ?? this.totalOrders,
            oderData: oderData ?? this.oderData,
        );

    factory MyOrderModel.fromJson(Map<String, dynamic> json) => MyOrderModel(
        success: json["success"],
        customerId: json["customerId"],
        totalOrders: json["totalOrders"],
        oderData: json["data"] == null ? [] : List<OderData>.from(json["data"]!.map((x) => OderData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "customerId": customerId,
        "totalOrders": totalOrders,
        "data": oderData == null ? [] : List<dynamic>.from(oderData!.map((x) => x.toJson())),
    };
}

class OderData {
    final int? orderId;
    final String? orderGuid;
    final double? orderSubtotal;
    final double? shippingCharges;
    final double? orderTotal;
    final String? orderStatus;
    final String? paymentMethod;
    final String? paymentStatus;
    final String? createdDate;
    final List<Item>? items;

    OderData({
        this.orderId,
        this.orderGuid,
        this.orderSubtotal,
        this.shippingCharges,
        this.orderTotal,
        this.orderStatus,
        this.paymentMethod,
        this.paymentStatus,
        this.createdDate,
        this.items,
    });

    OderData copyWith({
        int? orderId,
        String? orderGuid,
        double? orderSubtotal,
        double? shippingCharges,
        double? orderTotal,
        String? orderStatus,
        String? paymentMethod,
        String? paymentStatus,
        String? createdDate,
        List<Item>? items,
    }) => 
        OderData(
            orderId: orderId ?? this.orderId,
            orderGuid: orderGuid ?? this.orderGuid,
            orderSubtotal: orderSubtotal ?? this.orderSubtotal,
            shippingCharges: shippingCharges ?? this.shippingCharges,
            orderTotal: orderTotal ?? this.orderTotal,
            orderStatus: orderStatus ?? this.orderStatus,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            paymentStatus: paymentStatus ?? this.paymentStatus,
            createdDate: createdDate ?? this.createdDate,
            items: items ?? this.items,
        );

    factory OderData.fromJson(Map<String, dynamic> json) => OderData(
        orderId: json["order_id"],
        orderGuid: json["order_guid"],
        orderSubtotal: json["order_subtotal"]?.toDouble(),
        shippingCharges: json["shipping_charges"]?.toDouble(),
        orderTotal: json["order_total"]?.toDouble(),
        orderStatus: json["order_status"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        createdDate: json["created_date"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_guid": orderGuid,
        "order_subtotal": orderSubtotal,
        "shipping_charges": shippingCharges,
        "order_total": orderTotal,
        "order_status": orderStatus,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "created_date": createdDate,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    final int? orderItemId;
    final int? productId;
    final int? variantId;
    final String? productName;
    final int? qty;
    final double? salePrice;
    final double? totalPrice;
    final String? size;
    final String? color;
    final String? productImage;

    Item({
        this.orderItemId,
        this.productId,
        this.variantId,
        this.productName,
        this.qty,
        this.salePrice,
        this.totalPrice,
        this.size,
        this.color,
        this.productImage,
    });

    Item copyWith({
        int? orderItemId,
        int? productId,
        int? variantId,
        String? productName,
        int? qty,
        double? salePrice,
        double? totalPrice,
        String? size,
        String? color,
        String? productImage,
    }) => 
        Item(
            orderItemId: orderItemId ?? this.orderItemId,
            productId: productId ?? this.productId,
            variantId: variantId ?? this.variantId,
            productName: productName ?? this.productName,
            qty: qty ?? this.qty,
            salePrice: salePrice ?? this.salePrice,
            totalPrice: totalPrice ?? this.totalPrice,
            size: size ?? this.size,
            color: color ?? this.color,
            productImage: productImage ?? this.productImage,
        );

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        orderItemId: json["order_item_id"],
        productId: json["product_id"],
        variantId: json["variantId"],
        productName: json["product_name"],
        qty: json["qty"],
        salePrice: json["sale_price"]?.toDouble(),
        totalPrice: json["total_price"]?.toDouble(),
        size: json["Size"],
        color: json["Color"],
        productImage: json["ProductImage"],
    );

    Map<String, dynamic> toJson() => {
        "order_item_id": orderItemId,
        "product_id": productId,
        "variantId": variantId,
        "product_name": productName,
        "qty": qty,
        "sale_price": salePrice,
        "total_price": totalPrice,
        "Size": size,
        "Color": color,
        "ProductImage": productImage,
    };
}
