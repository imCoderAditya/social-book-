import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/product_details_model.dart';


class VariantSelector extends StatelessWidget {
  final List<Variant> variants;
  final Variant? selectedVariant;
  final Function(Variant) onVariantSelected;
  final bool isDark;

  const VariantSelector({
    super.key,
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Size',
            style: AppTextStyles.headlineMedium(),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: variants.map((variant) {
              final isSelected = selectedVariant?.sizeId == variant.sizeId;
              final isOutOfStock = variant.stock == null || variant.stock! <= 0;

              return GestureDetector(
                onTap: isOutOfStock ? null : () => onVariantSelected(variant),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected && !isOutOfStock
                        ? LinearGradient(
                            colors: AppColors.headerGradientColors,
                          )
                        : null,
                    color: isSelected && !isOutOfStock
                        ? null
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                    border: Border.all(
                      color: isSelected && !isOutOfStock
                          ? Colors.transparent
                          : (isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        variant.sizeId ?? '',
                        style: AppTextStyles.body().copyWith(
                          color: isSelected && !isOutOfStock
                              ? Colors.white
                              : (isOutOfStock
                                  ? (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary)
                                  : (isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                          fontWeight: FontWeight.w600,
                          decoration: isOutOfStock
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (variant.price != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          '\u20B9 ${variant.price!.toStringAsFixed(2)}',
                          style: AppTextStyles.caption().copyWith(
                            color: isSelected && !isOutOfStock
                                ? Colors.white.withOpacity(0.9)
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                      if (isOutOfStock) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'Out of Stock',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.red,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
