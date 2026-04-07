import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/app_drawer.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/theme_controller.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/modules/home/hidden/views/hidden_view.dart';
import 'package:social_book/app/modules/home/matrimonial/views/matrimonial_view.dart';
import 'package:social_book/app/modules/home/professinal/views/professional_view.dart';
import 'package:social_book/app/modules/home/social/views/social_view.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/modules/story/controllers/story_controller.dart';
import 'package:social_book/app/modules/story/views/story_view.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart'
    show LocalStorageService;
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: _buildAppBar(context, isDark, height, width),
          drawer: AppDrawer(),
          body: _buildBody(context, isDark, height, width),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {},
          //   backgroundColor: AppColors.primaryColor,
          //   child: const Icon(Icons.add, color: Colors.white),
          // ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    double height,
    double width,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 1,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: Text(
        'A Social Book',
        style: TextStyle(
          color:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: height * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkBackground : AppColors.lightBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              size: height * 0.028,
            ),
          ),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_alt_sharp,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                  size: height * 0.028,
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.ADD_FRIENDS);
              },
            ),
            Positioned(
              right: width * 0.016,
              top: height * -0.001,
              child: Container(
                padding: EdgeInsets.all(width * 0.01),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: width * 0.045,
                  minHeight: width * 0.045,
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.012,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                  size: height * 0.028,
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.NOTIFICATION);
              },
            ),
            Positioned(
              right: width * 0.016,
              top: height * -0.001,
              child: Container(
                padding: EdgeInsets.all(width * 0.01),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: width * 0.045,
                  minHeight: width * 0.045,
                ),
                child: Center(
                  child: Text(
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.012,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: width * 0.01),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isDark,
    double height,
    double width,
  ) {
    final storyController =
        Get.isRegistered<StoryController>()
            ? Get.find<StoryController>()
            : Get.put(StoryController());
    return RefreshIndicator(
      onRefresh: () async {
        controller.postList.clear();
        await controller.fetchSocialPost();
      },
      child: SingleChildScrollView(
        controller: controller.postScrollController,

        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            // Stories Section
            Obx(
              () =>
                  storyController.storyModel.value == null
                      ? SizedBox()
                      : SizedBox(height: 120.h, child: StoryView()),
            ),

            Divider(
              height: height * 0.015,
              thickness: height * 0.01,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            Obx(() => _viewUi(controller.selectIndex.value)),
          ],
        ),
      ),
    );
  }

  Widget _viewUi(int value) {
    debugPrint(controller.selectIndex.value.toString());

    final profileType = LocalStorageService.getProfileType();
    LoggerUtils.debug("Logger: $profileType");
    switch (profileType) {
      case "Social":
        return SocialView();
      case "Professional":
        return ProfessionalView();
      case "Hidden":
        return HiddenView();
      case "Matrimonial":
        return MatrimonialView();
      default:
        return SocialView();
    }
  }

  // Widget _buildCategoryChip(
  //   BuildContext context,
  //   bool isDark,
  //   double height,
  //   double width,
  //   String label,
  //   bool isSelected,
  //   int index,
  // ) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: width * 0.015,
  //       vertical: height * 0.01,
  //     ),
  //     child: ChoiceChip(
  //       label: Text(label),
  //       selected: isSelected,

  //       onSelected: (selected) {
  //         controller.selectIndex.value = index;
  //         controller.selectProfileType(profileType: label);
  //       },
  //       selectedColor: AppColors.primaryColor,
  //       iconTheme: IconThemeData(color: AppColors.white),
  //       showCheckmark: true,
  //       checkmarkColor: AppColors.white,
  //       backgroundColor:
  //           isDark ? AppColors.darkBackground : AppColors.lightBackground,
  //       labelStyle: TextStyle(
  //         color:
  //             isSelected
  //                 ? Colors.white
  //                 : (isDark
  //                     ? AppColors.darkTextPrimary
  //                     : AppColors.lightTextPrimary),
  //         fontSize: height * 0.018,
  //         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //       ),
  //       padding: EdgeInsets.symmetric(
  //         horizontal: width * 0.04,
  //         vertical: height * 0.01,
  //       ),
  //     ),
  //   );
  // }
}
