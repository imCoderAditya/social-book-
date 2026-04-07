import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_friends_controller.dart';

class UserFriendsView extends GetView<UserFriendsController> {
  const UserFriendsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserFriendsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserFriendsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
