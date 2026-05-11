import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/ui/widgets/object_detail_buttons.dart';
import 'package:space_app/ui/widgets/space_object_builder.dart';

class ObjectDetailScreen extends ConsumerWidget {
  final SpaceObject spaceobject;

  const ObjectDetailScreen({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(spaceobject.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: SpaceObjectImage(
                imagePath: spaceobject.imagePath,
                category: spaceobject.category,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spaceobject.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Category: ${spaceobject.category}",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(spaceobject.description),
                  const SizedBox(height: 16),
                  const Text(
                    "Personal Notes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    spaceobject.notes.isEmpty
                        ? "No notes added."
                        : spaceobject.notes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ObjectActionButtons(spaceobject: spaceobject),
    );
  }
}
