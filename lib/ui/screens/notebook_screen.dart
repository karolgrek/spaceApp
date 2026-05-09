import 'package:flutter/material.dart';
import 'package:space_app/ui/widgets/add_object_button.dart';
import 'package:space_app/ui/widgets/object_card.dart';
import 'package:space_app/ui/widgets/search_bar.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              itemCount: 10,
              itemBuilder: (context, index) {
                return const ObjectCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
