import 'package:flutter/material.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/ui/widgets/object/object_card.dart';

class CategoryObjectsSection extends StatelessWidget {
  final String categoryName;
  final List<SpaceObject> objects;

  const CategoryObjectsSection({
    super.key,
    required this.categoryName,
    required this.objects,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(categoryName, style: const TextStyle(fontSize: 22)),
        const Divider(color: Colors.white24, thickness: 2),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: objects.length,
          itemBuilder: (context, gridIndex) {
            return ObjectCard(spaceObject: objects[gridIndex]);
          },
        ),
      ],
    );
  }
}
