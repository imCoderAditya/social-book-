import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:social_book/app/data/models/onlineUser/online_user_model.dart';
import 'package:social_book/app/routes/webshoket/user_session_services.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';
// import 'package:social_book/app/data/models/onlineUser/online_user_model.dart';
// import 'package:social_book/app/routes/webshoket/user_session_services.dart';

class OnlineUserController extends GetxController {
  final RxList<OnlineUser> filteredUsers = <OnlineUser>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<OnlineUserModel> onlineUserModel = Rxn<OnlineUserModel>();
  @override
  void onInit() {
    super.onInit();
    userChat();
  }

  final socketService = UserChatService();

  void userChat() async {
    await socketService.connect();

    socketService.listen(
      onData: (data) {
        log("📩 WS Response => ${json.encode(data)}");

        onlineUserModel.value = onlineUserModelFromJson(json.encode(data));
        log("📩 WS Response Model=> ${json.encode(onlineUserModel.value)}");
        filteredUsers.addAll(onlineUserModel.value?.onlineUser ?? []);
      },
      onError: (e) {
        log("❌ WS Error => $e");
      },
      onDone: () {
        log("🔌 WS Closed");
      },
    );
    final profileType = LocalStorageService.getProfileType();
    socketService.getSessions(
      sessionType: profileType ?? "",
      pageNumber: 1,
      pageSize: 20,
    );
  }

  void searchUsers(String query) {
    final search = query.trim().toLowerCase();
    // searchQuery.value = query;

    final users = onlineUserModel.value?.onlineUser ?? [];

    // 🔹 If search empty → show all users
    if (search.isEmpty) {
      filteredUsers.value = users;
      log("====>${json.encode(users)}");
      return;
    }

    // 🔹 Local filter
    filteredUsers.value =
        users
            .where(
              (user) =>
                  (user.otherDisplayName ?? '').toLowerCase().contains(search),
            )
            .toList();
    log("filteredUsers search ====>${json.encode(filteredUsers)}");
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredUsers.value = onlineUserModel.value?.onlineUser ?? [];
  }

  void sendMessage(OnlineUser user) {
    Get.snackbar('Chat', 'Opening chat with ${user.myDisplayName ?? ""}');
  }

  void viewProfile(OnlineUser user) {
    Get.snackbar('Profile', 'Viewing ${user.myDisplayName}\'s profile');
  }
}
