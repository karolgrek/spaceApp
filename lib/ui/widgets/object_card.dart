import 'package:flutter/material.dart';
import 'package:space_app/models/space_object.dart';
import 'dart:io';

import 'package:space_app/ui/widgets/space_object_builder.dart';

class ObjectCard extends StatelessWidget {
  final SpaceObject spaceobject;
  const ObjectCard({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SpaceObjectImage(
                imagePath: spaceobject.imagePath,
                category: spaceobject.category,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Text(
              spaceobject.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: SizedBox(
              height: 36,
              child: Text(
                spaceobject.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    // Ak nie je žiadna cesta, ukáž ikonu
    if (spaceobject.imagePath.isEmpty) {
      return Container(
        color: Colors.grey[800],
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      );
    }

    // Skús načítať ako súbor (ak má cestu, ktorú sme si vybrali)
    final file = File(spaceobject.imagePath);
    if (file.existsSync()) {
      return Image.file(file, width: double.infinity, fit: BoxFit.cover);
    }

    // Skús načítať ako asset (pre štandardné obrázky, ak by sme ich pridali neskôr)
    return Image.asset(
      spaceobject.imagePath,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
