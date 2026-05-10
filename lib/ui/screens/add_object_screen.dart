import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/space_object_builder.dart';
import 'package:image_picker/image_picker.dart';

class AddNewObject extends ConsumerStatefulWidget {
  final SpaceObject? objectToEdit;
  const AddNewObject({super.key, this.objectToEdit});

  @override
  ConsumerState<AddNewObject> createState() => _AddNewObjectState();
}

class _AddNewObjectState extends ConsumerState<AddNewObject> {
  final List<String> _categories = [];
  String? _selectedCategory;
  String _selectedImagePath = '';

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _customCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final customCategories = ref.read(customCategoriesProvider);
    _categories.clear();
    _categories.addAll(customCategories);
    _categories.add('Create custom...');
    if (widget.objectToEdit != null) {
      _nameController.text = widget.objectToEdit!.name;
      _selectedCategory = widget.objectToEdit!.category;
      _descriptionController.text = widget.objectToEdit!.description;
      _notesController.text = widget.objectToEdit!.notes;
      _selectedImagePath = widget.objectToEdit!.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void saveObject() {
      String newCategory = _selectedCategory!;
      if (_selectedCategory == 'Create custom...') {
        newCategory = _customCategoryController.text.trim();
        if (newCategory.isEmpty) return;
        ref.read(customCategoriesProvider.notifier).addCategory(newCategory);
      }

      final name = _nameController.text.trim();
      if (name.isEmpty || _selectedCategory == null) return;
      final objectId =
          widget.objectToEdit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = _selectedImagePath;

      final savedObject = SpaceObject(
        id: objectId,
        name: name,
        category: newCategory,
        description: _descriptionController.text.trim(),
        imagePath: imagePath,
        notes: _notesController.text.trim(),
      );

      if (widget.objectToEdit != null) {
        ref.read(spaceObjectsProvider.notifier).updateObject(savedObject);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Object updated!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ref.read(spaceObjectsProvider.notifier).addObject(savedObject);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New object "$name" has been created.'),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Space Object")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                setState(() {
                  _selectedImagePath = image.path;
                });
              }
            },
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
                    imagePath: _selectedImagePath,
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
                          _selectedImagePath.isNotEmpty
                              ? "Tap to change photo"
                              : "Tap to upload a photo",
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

          if (_selectedCategory == 'Create custom...') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _customCategoryController,
              decoration: const InputDecoration(
                labelText: "Enter custom category name",
                border: OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: "Short Description",
              hintText: "Brief text for the home screen (max 100 chars)",
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            minLines: 6,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: "Personal Notes",
              hintText: "Any notes?",
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 32),

          if (widget.objectToEdit != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => saveObject(),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => saveObject(),
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
