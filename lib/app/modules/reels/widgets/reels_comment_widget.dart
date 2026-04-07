import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:social_book/app/components/app_loader.dart';
import 'package:social_book/app/components/user_avatar.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/utils/date_utils.dart' show AppDateUtils;
import 'package:social_book/app/data/models/reels/reel_comments_model.dart';

import 'package:social_book/app/modules/reels/controllers/reels_controller.dart';

class ReelsCommentWidget extends StatelessWidget {
  const ReelsCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    return GetBuilder<ReelsController>(
      init: ReelsController(),
      builder: (controller) {
        final data = controller.reelCommentModel.value?.data;
        final comments =
            controller.reelCommentModel.value?.data?.comments ?? [];

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
                            Icon(Icons.send, color: Colors.grey[600], size: 22),
                          ],
                        ),
                      ),

                      // Comments list
                      Expanded(
                        child:
                            comments.isEmpty
                                ? Center(
                                  child: Text(
                                    "No Commenet",
                                    style: AppTextStyles.headlineMedium(),
                                  ),
                                )
                                : ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  itemCount: comments.length,
                                  itemBuilder:
                                      (context, index) => _buildCommentItem(
                                        index: index,
                                        reelComment: comments[index],
                                      ),
                                ),
                      ),

                      // Comment input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: SafeArea(
                          child: Row(
                            children: [
                              UserAvatar(),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  if (commentController.text.isNotEmpty) {
                                    // Handle post comment
                                    final createComment = await controller
                                        .createComments(
                                          commentText: commentController.text,
                                          postId: data?.postId,
                                          parentCommentId: null,
                                          mediaFile: null,
                                        );
                                    if (createComment) {
                                      commentController.clear();
                                      focusNode.unfocus();
                                    }
                                  }
                                },
                                child: Obx(
                                  () =>
                                      controller.isLoading.value
                                          ? AppCircleLoader()
                                          : Text(
                                            'Post',
                                            style: TextStyle(
                                              color: Colors.blue[600],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildCommentItem({required int index, Comment? reelComment}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(reelComment?.profilePicture ?? ""),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: reelComment?.displayName ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "\t"),
                      TextSpan(
                        text: reelComment?.commentText ?? "",
                        style: TextStyle(color: Colors.grey[900]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      AppDateUtils.timeAgo(
                        reelComment?.createdAt.toString() ?? '',
                      )??"",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 16),
                    reelComment?.loveReactionCount == 0
                        ? SizedBox()
                        : Text(
                          '${reelComment?.loveReactionCount ?? ""} likes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    reelComment?.loveReactionCount == 0
                        ? SizedBox()
                        : const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(
                index % 4 == 0 ? Icons.favorite : Icons.favorite_border,
                size: 14,
                color: index % 4 == 0 ? Colors.red : Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
