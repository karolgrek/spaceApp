import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/ui/widgets/category/category_tile.dart';

class EditCategoriesScreen extends ConsumerWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCategories = [
      'Planet',
      'Star',
      'Galaxy',
      'Comet',
      'Black Hole',
      'Moon',
      'Satellite',
    ];
    final customCategories = ref
        .watch(customCategoriesProvider)
        .where((c) => !baseCategories.contains(c))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Categories")),
      body: customCategories.isEmpty
          ? const Center(
              child: Text(
                "You haven't created any custom categories yet.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customCategories.length,
              itemBuilder: (context, index) {
                return CategoryTile(category: customCategories[index]);
              },
            ),
    );
  }
}
