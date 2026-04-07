// order_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';

import 'package:social_book/app/core/utils/date_utils.dart';

import 'package:social_book/app/data/models/ecommerce/my_order_model.dart';
import 'package:social_book/app/modules/ecommerce/order/controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchOrder();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'My Orders',
          style: AppTextStyles.headlineMedium().copyWith(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.myOrderModel.value?.oderData ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Text(
              'No orders found',
              style: AppTextStyles.headlineMedium(),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              onTap: () {
                OrderBottomSheet.show(context, order);
              },
            );
          },
        );
      }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OderData order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemCount = order.items?.length ?? 0;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: AppTextStyles.headlineMedium(),
                  ),
                  _buildStatusChip(order.orderStatus, isDark),
                ],
              ),
              SizedBox(height: 8.h),

              // Date
              Text(
                AppDateUtils.extractDate(order.createdDate, 14),
                style: AppTextStyles.caption(),
              ),
              SizedBox(height: 12.h),

              // Items Count
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 18.sp,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                    style: AppTextStyles.caption(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount', style: AppTextStyles.small()),
                      Text(
                        '₹${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}',
                        style: AppTextStyles.headlineMedium().copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status, bool isDark) {
    Color backgroundColor;
    Color textColor;

    switch (status?.toLowerCase()) {
      case 'delivered':
        backgroundColor = AppColors.green.withOpacity(0.2);
        textColor = AppColors.green;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status ?? 'Unknown',
        style: AppTextStyles.small().copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class OrderBottomSheet {
  static void show(BuildContext context, OderData order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle Bar
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Details',
                            style: AppTextStyles.headlineLarge(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1.h),

                    // Order Info
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Order ID',
                            '#${order.orderId}',
                            isDark,
                          ),
                          SizedBox(height: 8.h),
                          _buildInfoRow(
                            'Date',
                            AppDateUtils.extractDate(order.createdDate, 14),
                            isDark,
                          ),
                          SizedBox(height: 8.h),
                          _buildInfoRow(
                            'Payment',
                            '${order.paymentMethod} - ${order.paymentStatus}',
                            isDark,
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1.h),

                    // Items List
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.all(16.w),
                        itemCount: order.items?.length ?? 0,
                        separatorBuilder:
                            (context, index) => Divider(height: 24.h),
                        itemBuilder: (context, index) {
                          final item = order.items![index];
                          return OrderItemTile(item: item);
                        },
                      ),
                    ),

                    // Footer Summary
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        border: Border(
                          top: BorderSide(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Subtotal',
                            order.orderSubtotal,
                            isDark,
                          ),
                          SizedBox(height: 8.h),
                          _buildSummaryRow(
                            'Shipping',
                            order.shippingCharges,
                            isDark,
                          ),
                          Divider(height: 16.h),
                          _buildSummaryRow(
                            'Total',
                            order.orderTotal,
                            isDark,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  static Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption()),
        Text(
          value,
          style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  static Widget _buildSummaryRow(
    String label,
    double? amount,
    bool isDark, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal ? AppTextStyles.headlineMedium() : AppTextStyles.body(),
        ),
        Text(
          '₹${amount?.toStringAsFixed(2) ?? '0.00'}',
          style:
              isTotal
                  ? AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.primaryColor,
                  )
                  : AppTextStyles.body(),
        ),
      ],
    );
  }
}

class OrderItemTile extends StatelessWidget {
  final Item item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedNetworkImage(
            imageUrl: item.productImage ?? '',
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 32.sp,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                ),
          ),
        ),
        SizedBox(width: 12.w),

        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName ?? 'Unknown Product',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),

              // Size & Color
              if (item.size != null || item.color != null)
                Row(
                  children: [
                    if (item.size != null) ...[
                      Text('Size: ${item.size}', style: AppTextStyles.small()),
                      if (item.color != null) SizedBox(width: 8.w),
                    ],
                    if (item.color != null) ...[
                      Text('Color: ', style: AppTextStyles.small()),
                      Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: _parseColor(item.color),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ],
                ),
              SizedBox(height: 4.h),

              // Quantity & Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qty: ${item.qty}', style: AppTextStyles.caption()),
                  Text(
                    '₹${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return Colors.grey;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
