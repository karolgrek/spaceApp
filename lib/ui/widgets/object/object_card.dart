import 'package:flutter/material.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/ui/screens/object_detail_screen.dart';
import 'package:space_app/ui/widgets/object/space_object_builder.dart';

class ObjectCard extends StatelessWidget {
  final SpaceObject spaceobject;

  const ObjectCard({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObjectDetailScreen(spaceobject: spaceobject),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SpaceObjectImage(
                imagePath: spaceobject.imagePath,
                category: spaceobject.category,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spaceobject.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 36,
                    child: Text(
                      spaceobject.description.isEmpty
                          ? "No description."
                          : spaceobject.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
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
