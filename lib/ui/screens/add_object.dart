import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/space_object_builder.dart';

class AddNewObject extends ConsumerStatefulWidget {
  const AddNewObject({super.key});

  @override
  ConsumerState<AddNewObject> createState() => _AddNewObjectState();
}

class _AddNewObjectState extends ConsumerState<AddNewObject> {
  final List<String> _categories = [
    'Planet',
    'Star',
    'Galaxy',
    'Comet',
    'Black Hole',
    'Moon',
    'Satellite',
    'Custom...',
  ];
  String? _selectedCategory;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Space Object")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 200,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SpaceObjectImage(
                    imagePath: '',
                    category: _selectedCategory ?? '',
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tap to upload a photo",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Space object name",
              hintText: "Earth C-137 / Asgard - home of Thor",
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Category'),
            value: _selectedCategory,
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: "Short Description",
              hintText: "Brief text for the home screen (max 100 chars)",
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: "Personal Notes",
              hintText: "Any notes?",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty || _selectedCategory == null) {
                return;
              }
              final newObject = SpaceObject(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                category: _selectedCategory!,
                description: _descriptionController.text.trim(),
                imagePath: '',
                notes: _notesController.text.trim(),
              );
              ref.read(spaceObjectsProvider.notifier).addObject(newObject);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('New object "$name" has been created.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
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
