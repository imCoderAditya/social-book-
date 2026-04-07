import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/product_details_model.dart'
    as model;
class ColorSelector extends StatelessWidget {
  final List<model.Color> colors;
  final model.Color? selectedColor;
  final Function(model.Color) onColorSelected;
  final bool isDark;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Color',
            style: AppTextStyles.headlineMedium(),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: colors.map((color) {
              final isSelected = selectedColor?.colorId == color.colorId;


              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: hexToColor(color.colorId??""),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : (isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider),
                      width: isSelected ? 3 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha:0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: isDark
                              ? Colors.black
                              : Colors.white,
                          size: 24.sp,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          if (selectedColor?.colorId != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Color: ${_formatColorName(selectedColor!.colorId!)}',
              style: AppTextStyles.caption().copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }



  String _formatColorName(String colorId) {
    // Capitalize first letter
    if (colorId.isEmpty) return colorId;
    return colorId[0].toUpperCase() + colorId.substring(1).toLowerCase();
  }

  
}
