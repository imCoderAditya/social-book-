import 'package:get/get.dart';

class NotificationController extends GetxController {
  String selectedTab = 'all';
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> filteredNotifications = [];

  @override
  void onInit() {
    super.onInit();
    // Sample notifications
    notifications = [
      {
        'id': 1,
        'user': 'John Doe',
        'message': 'liked your post',
        'time': '2 min ago',
        'type': 'like',
        'isRead': false,
      },
      {
        'id': 2,
        'user': 'Jane Smith',
        'message': 'commented on your photo',
        'time': '15 min ago',
        'type': 'comment',
        'isRead': false,
      },
      {
        'id': 3,
        'user': 'Mike Johnson',
        'message': 'sent you a friend request',
        'time': '1 hour ago',
        'type': 'friend_request',
        'isRead': false,
      },
      {
        'id': 4,
        'user': 'Sarah Williams',
        'message': 'shared your post',
        'time': '2 hours ago',
        'type': 'share',
        'isRead': true,
      },
      {
        'id': 5,
        'user': 'David Brown',
        'message': 'accepted your friend request',
        'time': '3 hours ago',
        'type': 'friend_accept',
        'isRead': true,
      },
      {
        'id': 6,
        'user': 'Emily Davis',
        'message': 'mentioned you in a comment',
        'time': '5 hours ago',
        'type': 'mention',
        'isRead': false,
      },
      {
        'id': 7,
        'user': 'Chris Wilson',
        'message': 'has a birthday today',
        'time': '1 day ago',
        'type': 'birthday',
        'isRead': true,
      },
      {
        'id': 8,
        'user': 'Lisa Anderson',
        'message': 'invited you to an event',
        'time': '2 days ago',
        'type': 'event',
        'isRead': true,
      },
      {
        'id': 9,
        'user': 'Tom Harris',
        'message': 'liked your comment',
        'time': '3 days ago',
        'type': 'like',
        'isRead': false,
      },
      {
        'id': 10,
        'user': 'Anna Martinez',
        'message': 'shared your photo',
        'time': '4 days ago',
        'type': 'share',
        'isRead': true,
      },
    ];
    filteredNotifications = List.from(notifications);
  }

  void changeTab(String tab) {
    selectedTab = tab;
    if (tab == 'all') {
      filteredNotifications = List.from(notifications);
    } else {
      filteredNotifications = notifications
          .where((notification) => !(notification['isRead'] as bool))
          .toList();
    }
    update();
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      changeTab(selectedTab);
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    changeTab(selectedTab);
  }

  void deleteNotification(int id) {
    notifications.removeWhere((n) => n['id'] == id);
    changeTab(selectedTab);
  }
}