import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:space_app/ui/widgets/object/space_object_builder.dart';

class ObjectImagePicker extends StatelessWidget {
  final String imagePath;
  final String category;
  final ValueChanged<String> onImageSelected;

  const ObjectImagePicker({
    super.key,
    required this.imagePath,
    required this.category,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          onImageSelected(image.path);
        }
      },
      child: Container(
        height: 200,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SpaceObjectImage(
              imagePath: imagePath,
              category: category,
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    imagePath.isNotEmpty
                        ? "Tap to change photo"
                        : "Tap to upload a photo",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
