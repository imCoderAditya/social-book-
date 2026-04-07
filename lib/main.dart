import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_book/app/components/restart_widget.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/modules/controller/user_controller.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';
import 'package:social_book/app/modules/nav/controllers/nav_controller.dart';
import 'package:social_book/app/modules/newPost/controllers/new_post_controller.dart';
import 'package:social_book/app/modules/onlineUser/controllers/online_user_controller.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/modules/reels/controllers/reels_controller.dart';
import 'package:social_book/app/services/common_services/like_service.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';
import 'app/core/config/theme/app_theme.dart';
import 'app/core/config/theme/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseClient.initialize(EndPoint.baseurl);
  await GetStorage.init();
  await LocalStorageService.loadPrimaryColor();

  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  Get.put(LikeService());
  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = Get.put(ThemeController());
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      key: key,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return Obx(() {
          final isDark = themeController.isDarkMode.value;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: "Social Book",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              initialBinding: BindingsBuilder(() {
                Get.lazyPut(() => ThemeController());
                Get.lazyPut(() => NewPostController());
                Get.lazyPut(() => NavController());
                Get.lazyPut(() => HomeController());
                Get.lazyPut(() => ReelsController());
                Get.lazyPut(() => OnlineUserController());
                Get.lazyPut(() => ProfileController());
                Get.lazyPut(() => UserController());
              }),
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(0.8)),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            ),
          );
        });
      },
      child: const Placeholder(),
    );
  }
}
