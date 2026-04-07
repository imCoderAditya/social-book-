import 'package:get/get.dart';

import '../modules/addFriends/bindings/add_friends_binding.dart';
import '../modules/addFriends/views/add_friends_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otpVerify/bindings/otp_verify_binding.dart';
import '../modules/auth/otpVerify/views/otp_verify_view.dart';
import '../modules/auth/profileRegistration/bindings/profile_registration_binding.dart';
import '../modules/auth/profileRegistration/views/profile_registration_view.dart';
import '../modules/auth/profileSelection/bindings/profile_selection_binding.dart';
import '../modules/auth/profileSelection/views/profile_selection_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/auth/signupVerification/bindings/signup_verification_binding.dart';
import '../modules/auth/signupVerification/views/signup_verification_view.dart';
import '../modules/calls/bindings/calls_binding.dart';
import '../modules/calls/views/calls_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/ecommerce/addAddress/bindings/add_address_binding.dart';
import '../modules/ecommerce/addAddress/views/add_address_view.dart';
import '../modules/ecommerce/address/bindings/address_binding.dart';
import '../modules/ecommerce/address/views/address_view.dart';
import '../modules/ecommerce/cart/bindings/cart_binding.dart';
import '../modules/ecommerce/cart/views/cart_view.dart';
import '../modules/ecommerce/order/bindings/order_binding.dart';
import '../modules/ecommerce/order/views/order_view.dart';
import '../modules/ecommerce/product_details/bindings/product_details_binding.dart';
import '../modules/ecommerce/product_details/views/product_details_view.dart';
import '../modules/ecommerce/store/bindings/store_binding.dart';
import '../modules/ecommerce/store/views/store_view.dart';
import '../modules/ecommerce/summary/bindings/summary_binding.dart';
import '../modules/ecommerce/summary/views/summary_view.dart';
import '../modules/editProfile/bindings/edit_profile_binding.dart';
import '../modules/editProfile/views/edit_profile_view.dart';
import '../modules/friends/bindings/friends_binding.dart';
import '../modules/friends/views/friends_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/comment/bindings/comment_binding.dart';
import '../modules/home/comment/views/comment_view.dart';
import '../modules/home/hidden/bindings/hidden_binding.dart';
import '../modules/home/hidden/views/hidden_view.dart';
import '../modules/home/matrimonial/bindings/matrimonial_binding.dart';
import '../modules/home/matrimonial/views/matrimonial_view.dart';
import '../modules/home/professinal/bindings/professional_binding.dart';
import '../modules/home/professinal/views/professional_view.dart';
import '../modules/home/social/bindings/social_binding.dart';
import '../modules/home/social/views/social_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mediaPreview/bindings/media_preview_binding.dart';
import '../modules/mediaPreview/views/media_preview_view.dart';
import '../modules/nav/bindings/nav_binding.dart';
import '../modules/nav/views/nav_view.dart';
import '../modules/newPost/bindings/new_post_binding.dart';
import '../modules/newPost/views/new_post_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onlineUser/bindings/online_user_binding.dart';
import '../modules/onlineUser/views/online_user_view.dart';
import '../modules/postUpload/bindings/post_upload_binding.dart';
import '../modules/postUpload/views/post_upload_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profileOtherUser/bindings/profile_other_user_binding.dart';
import '../modules/profileOtherUser/views/profile_other_user_view.dart';
import '../modules/reels/bindings/reels_binding.dart';
import '../modules/reels/views/reels_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/story/bindings/story_binding.dart';
import '../modules/story/views/story_view.dart';
import '../modules/switchProfile/bindings/switch_profile_binding.dart';
import '../modules/switchProfile/views/switch_profile_view.dart';
import '../modules/transcation/bindings/transcation_binding.dart';
import '../modules/transcation/views/transcation_view.dart';
import '../modules/userFriends/bindings/user_friends_binding.dart';
import '../modules/userFriends/views/user_friends_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.NAV,
      page: () => const NavView(),
      binding: NavBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.SOCIAL,
          page: () => const SocialView(),
          binding: SocialBinding(),
        ),
        GetPage(
          name: _Paths.PERSONAL,
          page: () => const ProfessionalView(),
          binding: ProfessionalBinding(),
        ),
        GetPage(
          name: _Paths.HIDDEN,
          page: () => const HiddenView(),
          binding: HiddenBinding(),
        ),
        GetPage(
          name: _Paths.MATRIMONIAL,
          page: () => const MatrimonialView(),
          binding: MatrimonialBinding(),
        ),
        GetPage(
          name: _Paths.COMMENT,
          page: () => const CommentView(),
          binding: CommentBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.REELS,
      page: () => const ReelsView(),
      binding: ReelsBinding(),
    ),
    GetPage(
      name: _Paths.CALLS,
      page: () => const CallsView(),
      binding: CallsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.USER_FRIENDS,
      page: () => const UserFriendsView(),
      binding: UserFriendsBinding(),
    ),
    GetPage(
      name: _Paths.ONLINE_USER,
      page: () => const OnlineUserView(),
      binding: OnlineUserBinding(),
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => const StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => const OtpVerifyView(),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_VERIFICATION,
      page: () => const SignupVerificationView(),
      binding: SignupVerificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SELECTION,
      page: () => const ProfileSelectionView(),
      binding: ProfileSelectionBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FRIENDS,
      page: () => const AddFriendsView(),
      binding: AddFriendsBinding(),
    ),
    GetPage(
      name: _Paths.SWITCH_PROFILE,
      page: () => const SwitchProfileView(),
      binding: SwitchProfileBinding(),
    ),
    GetPage(
      name: _Paths.FRIENDS,
      page: () => const FriendsView(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_REGISTRATION,
      page: () => const ProfileRegistrationView(),
      binding: ProfileRegistrationBinding(),
    ),
    GetPage(
      name: _Paths.NEW_POST,
      page: () => const NewPostView(),
      binding: NewPostBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.PROFILE_OTHER_USER,
      page: () => const ProfileOtherUserView(),
      binding: ProfileOtherUserBinding(),
      children: [
        GetPage(
          name: _Paths.PROFILE_OTHER_USER,
          page: () => const ProfileOtherUserView(),
          binding: ProfileOtherUserBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.ADDRESS,
      page: () => const AddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => const AddAddressView(),
      binding: AddAddressBinding(),
    ),
    GetPage(
      name: _Paths.SUMMARY,
      page: () => const SummaryView(),
      binding: SummaryBinding(),
    ),
    GetPage(
      name: _Paths.TRANSCATION,
      page: () => const TansactionView(),
      binding: TranscationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.STORY,
      page: () => const StoryView(),
      binding: StoryBinding(),
    ),
    GetPage(
      name: _Paths.MEDIA_PREVIEW,
      page: () => MediaPreviewView(),
      binding: MediaPreviewBinding(),
    ),
    GetPage(
      name: _Paths.POST_UPLOAD,
      page: () => const PostUploadView(),
      binding: PostUploadBinding(),
    ),
  ];
}
