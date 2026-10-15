import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/buttons/favorite_icon_button.dart';
import 'package:space_app/ui/widgets/buttons/object_detail_buttons.dart';
import 'package:space_app/ui/widgets/object/space_object_builder.dart';

class ObjectDetailScreen extends ConsumerWidget {
  final SpaceObject spaceObject;

  const ObjectDetailScreen({super.key, required this.spaceObject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allObjects = ref.watch(spaceObjectsProvider);
    final currentObject = allObjects.firstWhere(
      (obj) => obj.id == spaceObject.id,
      orElse: () => spaceObject,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(currentObject.name),
        actions: [
          FavoriteIconButton(spaceObject: currentObject),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: SpaceObjectImage(
                imagePath: currentObject.imagePath,
                category: currentObject.category,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentObject.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Category: ${currentObject.category}",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(currentObject.description),
                  const SizedBox(height: 16),
                  const Text(
                    "Personal Notes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentObject.notes.isEmpty
                        ? "No notes added."
                        : currentObject.notes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ObjectActionButtons(spaceObject: currentObject),
    );
  }
}
