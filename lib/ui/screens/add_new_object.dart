import 'package:flutter/material.dart';

class AddNewObject extends StatelessWidget {
  const AddNewObject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Space Object")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 60, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  "Tab to upload a photo",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: "Space object name",
              hintText:
                  "Andromeda Galaxy / Earth C-137 / Asgard - the home of Thor ",
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 6,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "A brief description of the space object",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Add Object",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
