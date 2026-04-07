import 'package:social_book/app/data/enums/riend_status.dart';

extension FriendStatusExt on FriendStatus {
  /// API ke liye
  String get apiValue {
    switch (this) {
      case FriendStatus.friend:
        return 'Friend';
      case FriendStatus.accepted:
        return 'Accepted';
      case FriendStatus.rejected:
        return 'Rejected';
      case FriendStatus.blocked:
        return 'Blocked';
    }
  }

  /// UI text
  String get label {
    switch (this) {
      case FriendStatus.friend:
        return 'Friend';
      case FriendStatus.accepted:
        return 'Accepted';
      case FriendStatus.rejected:
        return 'Rejected';
      case FriendStatus.blocked:
        return 'Blocked';
    }
  }

  /// API se enum
  static FriendStatus fromApi(String value) {
    return FriendStatus.values.firstWhere(
      (e) => e.apiValue == value.toUpperCase(),
      orElse: () => FriendStatus.friend,
    );
  }
}
