import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/apod/daily_picture_banner.dart';
import 'package:space_app/ui/widgets/buttons/add_new_object_button.dart';
import 'package:space_app/ui/widgets/category/category_filter_dialog.dart';
import 'package:space_app/ui/widgets/category/category_objects_section.dart';
import 'package:space_app/ui/widgets/common/search_bar.dart';
import 'package:space_app/ui/widgets/common/settings_drawer.dart';

class NotebookScreen extends ConsumerWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allObjects = ref.watch(spaceObjectsProvider);
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final displayedObjects = allObjects.where((obj) {
      final matchesCategory =
          selectedCategories.isEmpty ||
          selectedCategories.contains(obj.category);
      final matchesSearch = obj.name.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    final Map<String, List<SpaceObject>> groupedObjects = {};
    for (var obj in displayedObjects) {
      groupedObjects.putIfAbsent(obj.category, () => []).add(obj);
    }
    final categoriedObjects = groupedObjects.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Space Objects"),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const SettingsDrawer(),
      body: Column(
        children: [
          const DailyPictureBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Expanded(child: SearchBarWidget()),
                Badge.count(
                  count: selectedCategories.length,
                  isLabelVisible: selectedCategories.isNotEmpty,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => CategoryFilterDialog.show(context),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AddObjectButton(),
                const SizedBox(width: 12),
                const Text(
                  "Add new space object",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: categoriedObjects.length,
              itemBuilder: (context, index) {
                final categoryName = categoriedObjects[index];
                return CategoryObjectsSection(
                  categoryName: categoryName,
                  objects: groupedObjects[categoryName]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
