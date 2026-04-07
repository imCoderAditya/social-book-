import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';

class InstaMediaGridView extends StatelessWidget {

  final List<InstaAssetsExportData> mediaList;
  final Function(int index) onRemove;

  const InstaMediaGridView({
    super.key,
    required this.mediaList,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),

      itemCount: mediaList.length,

      itemBuilder: (context, index) {

        final file = mediaList[index].croppedFile;

        return Stack(

          children: [

            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: file != null
                    ? Image.file(file, fit: BoxFit.cover)
                    : const SizedBox(),
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => onRemove(index),
              ),
            ),

          ],
        );
      },
    );
  }
}