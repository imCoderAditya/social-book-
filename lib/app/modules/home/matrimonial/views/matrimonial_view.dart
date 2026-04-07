import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:social_book/app/components/circle_image_view.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';

class MatrimonialView extends StatelessWidget {
  const MatrimonialView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        _buildHeader(context, isDark, height, width),
        GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              // controller: controller.postScrollController,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.postList.length + 1,
              itemBuilder: (context, index) {
                if (index < controller.postList.length) {
                  final postData = controller.postList[index];
                  return _buildProfileCard(
                    context: context,
                    isDark: isDark,
                    height: height,
                    width: width,
                    index: index,
                    postData: postData,
                  );
                } else {
                  // 🔽 Bottom Loader
                  return Obx(() {
                    return controller.isLoading.value
                        ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : const SizedBox();
                  });
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    double height,
    double width,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.06,
      ),
      child: Column(
        children: [
          Icon(Icons.favorite, color: Colors.yellow[700], size: height * 0.08),
          SizedBox(height: height * 0.02),
          Text(
            'Find Your Perfect Match',
            style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            'Free Kundali matching & astrology reports',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: height * 0.018,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required bool isDark,
    required double height,
    required int index,
    required double width,
    PostData? postData,
  }) {
    return Container(
      margin: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(width * 0.03),
        border: Border(
          left: BorderSide(color: AppColors.primaryColor, width: width * 0.01),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleImageView(
                      image: postData?.profilePicture ?? "",
                      displayName: postData?.displayName ?? "",
                    ),
                    SizedBox(width: width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              postData?.displayName ?? "",
                              style: TextStyle(
                                color:
                                    isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                fontSize: height * 0.022,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              '• 27 years',
                              style: TextStyle(
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                fontSize: height * 0.018,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          '${postData?.profession ?? ""} • ${postData?.location ?? ""}',
                          style: TextStyle(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            fontSize: height * 0.016,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.school,
                  'MBA from IIM Ahmedabad',
                ),
                SizedBox(height: height * 0.012),
                _buildInfoRow(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.work,
                  'Senior Software Engineer at Google',
                ),
                SizedBox(height: height * 0.012),
                _buildInfoRow(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.location_on,
                  postData?.location ?? "",
                ),
                SizedBox(height: height * 0.012),
                _buildInfoRow(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.stars,
                  'Kundali Match Score: 28/36',
                ),
                SizedBox(height: height * 0.012),
                Row(
                  children: [
                    Icon(
                      Icons.brightness_2,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      size: height * 0.022,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      'Zodiac: Leo',
                      style: TextStyle(
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                        fontSize: height * 0.018,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(width * 0.01),
                      ),
                      child: Text(
                        '♌',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.016,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  postData?.content ?? "",
                  style: TextStyle(
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                    fontSize: height * 0.018,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                        ),
                        icon: Icon(Icons.favorite, size: height * 0.022),
                        label: Text(
                          'Send Interest',
                          style: TextStyle(
                            fontSize: height * 0.018,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    bool isDark,
    double height,
    double width,
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
          size: height * 0.022,
        ),
        SizedBox(width: width * 0.02),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              fontSize: height * 0.018,
            ),
          ),
        ),
      ],
    );
  }
}
