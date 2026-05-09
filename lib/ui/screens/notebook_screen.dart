import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/add_object_button.dart';
import 'package:space_app/ui/widgets/object_card.dart';
import 'package:space_app/ui/widgets/search_bar.dart';

class NotebookScreen extends ConsumerWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceObjectsList = ref.watch(spaceObjectsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("My Space Objects")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                const Expanded(child: SearchBarWidget()),
                const SizedBox(width: 8),
                const AddObjectButton(),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: spaceObjectsList.length,
              itemBuilder: (context, index) {
                final currentObject = spaceObjectsList[index];
                return ObjectCard(spaceobject: currentObject);
              },
            ),
          ),
        ],
      ),
    );
  }
}
