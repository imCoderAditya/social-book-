import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/chat_controller.dart';

/// WhatsApp-style chat UI with real-time messaging
class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: _buildAppBar(context, isDark),
          body: Column(
            children: [
              // Connection Status Indicator
              Obx(
                () =>
                    controller.isLoading.value
                        ? SizedBox()
                        : _buildConnectionStatus(),
              ),

              // Messages List
              Expanded(child: _buildMessagesList(isDark)),

              // Message Input Area
              _buildMessageInput(isDark),
            ],
          ),
        );
      },
    );
  }

  /// Build app bar with user info
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final userData = controller.onlineUser.value;
        return Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.white,
              child: CommonNetworkImage(
                borderRadius: BorderRadiusGeometry.circular(100),
                imageUrl: userData?.otherProfilePicture ?? "",
                errorIcon: Icons.person,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?.otherDisplayName ?? "User",
                    style: AppTextStyles.headlineMedium().copyWith(
                      color: AppColors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    userData?.otherLiveStatus == true
                        ? 'Active now'
                        : "Offline",
                    style: AppTextStyles.small().copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: AppColors.white, size: 22.sp),
          onPressed: () {
            // Implement call functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.videocam, color: AppColors.white, size: 24.sp),
          onPressed: () {
            // Implement video call functionality
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: AppColors.white, size: 22.sp),
          onSelected: (value) {
            if (value == 'clear') {
              _showClearChatDialog();
            } else if (value == 'refresh') {
              controller.refreshChat();
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Text('Refresh Chat'),
                ),
                const PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
              ],
        ),
      ],
    );
  }

  /// Build connection status indicator
  Widget _buildConnectionStatus() {
    return Obx(() {
      if (controller.isConnecting.value || controller.isLoading.value) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: Colors.orange.withValues(alpha: 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                controller.isConnecting.value ? 'Connecting...' : 'Loading...',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  /// Build messages list
  Widget _buildMessagesList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value && controller.messages.isEmpty) {
        return _chatShimmerList(isDark);
      }

      // 2. Agar loading khatam ho gayi aur phir bhi koi message nahi mila, tab "Empty State" dikhao
      if (!controller.isLoading.value && controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64.sp, color: Colors.grey),
              SizedBox(height: 16.h),
              Text('No messages yet', style: AppTextStyles.caption()),
              // ... baaki widgets
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        reverse: true,
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          return _buildMessageBubble(message, isDark);
        },
      );
    });
  }

  /// Build individual message bubble
  Widget _buildMessageBubble(message, bool isDark) {
    final isMe = message.isMine;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for other user
          if (!isMe) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
              child: Icon(
                Icons.person,
                size: 14.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 8.w),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient:
                    isMe
                        ? LinearGradient(
                          colors: AppColors.headerGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color:
                    isMe
                        ? null
                        : isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft:
                      isMe ? Radius.circular(18.r) : Radius.circular(4.r),
                  bottomRight:
                      isMe ? Radius.circular(4.r) : Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  Text(
                    message.messageContent,
                    style: AppTextStyles.caption().copyWith(
                      color:
                          isMe
                              ? AppColors.white
                              : isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Timestamp
                  Text(
                    _formatTime(message.createdAt),
                    style: AppTextStyles.small().copyWith(
                      color:
                          isMe
                              ? AppColors.white.withValues(alpha: 0.8)
                              : isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _chatShimmerList(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 8,
        physics:
            const AlwaysScrollableScrollPhysics(), // Scroll parent handle karega
        itemBuilder: (_, index) {
          final isMe = index % 2 == 0;

          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Avatar Shimmer for other user
                if (!isMe) ...[
                  CircleAvatar(radius: 14.r, backgroundColor: Colors.white),
                  SizedBox(width: 8.w),
                ],

                // Message Bubble Shimmer
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 0.7.sw,
                  ), // Screen width ka 70%
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                      bottomLeft:
                          isMe ? Radius.circular(18.r) : Radius.circular(4.r),
                      bottomRight:
                          isMe ? Radius.circular(4.r) : Radius.circular(18.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Fake Message Line 1
                      Container(
                        height: 12.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Fake Message Line 2 (Short)
                      Container(
                        height: 12.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Fake Timestamp
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 8.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMe) SizedBox(width: 8.w),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build message input area
  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add,color: AppColors.white,),
            ),

            // Text input field
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: controller.messageController,
                  style: AppTextStyles.caption().copyWith(fontSize: 14.sp),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                    hintText: 'Type a message...',
                    hintStyle: AppTextStyles.caption().copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Emoji button
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            size: 22.sp,
                          ),
                          onPressed: () {
                            // Implement emoji picker
                          },
                        ),

                        // Image button
                        IconButton(
                          icon: Icon(
                            Icons.image_outlined,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            size: 22.sp,
                          ),
                          onPressed: () {
                            // Implement image picker
                          },
                        ),
                      ],
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) {
                    controller.update(); // Update send button icon
                  },

                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.sendTextMessage(value.trim());
                    }
                  },
                ),
              ),
            ),

            SizedBox(width: 8.w),

            // Send/Voice button
            GetBuilder<ChatController>(
              builder: (ctrl) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      ctrl.messageController.text.trim().isEmpty
                          ? Icons.mic
                          : Icons.send,
                      color: AppColors.white,
                      size: 22.sp,
                    ),
                    onPressed: () {
                      if (ctrl.messageController.text.trim().isNotEmpty) {
                        ctrl.sendTextMessage(
                          ctrl.messageController.text.trim(),
                        );
                      } else {
                        // Implement voice recording
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show clear chat confirmation dialog
  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearChat();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Format timestamp for display
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      // Today - show time (HH:MM format)
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
