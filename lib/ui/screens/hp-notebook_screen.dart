import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/add_new_object_button.dart';
import 'package:space_app/ui/widgets/object_card.dart';
import 'package:space_app/ui/widgets/search_bar.dart';
import 'package:space_app/ui/screens/daily_picture_screen.dart';
import 'package:space_app/ui/widgets/daily_picture_banner.dart';

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
      if (!groupedObjects.containsKey(obj.category)) {
        groupedObjects[obj.category] = [];
      }
      groupedObjects[obj.category]!.add(obj);
    }
    final categoriedObjects = groupedObjects.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("My Space Objects")),
      body: Column(
        children: [
          const DailyPictureBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Expanded(child: SearchBarWidget()),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context, ref);
                  },
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
                final objectsInCategory = groupedObjects[categoryName]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName, style: const TextStyle(fontSize: 22)),
                    const Divider(color: Colors.white24, thickness: 2),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: objectsInCategory.length,
                      itemBuilder: (context, gridIndex) {
                        return ObjectCard(
                          spaceobject: objectsInCategory[gridIndex],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showFilterDialog(BuildContext context, WidgetRef ref) {
  final categories = [
    'Planet',
    'Star',
    'Galaxy',
    'Comet',
    'Black Hole',
    'Moon',
    'Satellite',
  ];

  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final selected = ref.watch(selectedCategoriesProvider);
          return AlertDialog(
            title: const Text('Filter by Category'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isChecked = selected.contains(cat);

                  return CheckboxListTile(
                    title: Text(cat),
                    value: isChecked,
                    onChanged: (bool? checked) {
                      final newList = List<String>.from(selected);
                      if (checked == true) {
                        newList.add(cat);
                      } else {
                        newList.remove(cat);
                      }
                      ref.read(selectedCategoriesProvider.notifier).state =
                          newList;
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    },
  );
}
