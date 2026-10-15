import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';
import 'package:space_app/ui/widgets/object/object_image_picker.dart';
import 'package:space_app/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

class AddNewObject extends ConsumerStatefulWidget {
  final SpaceObject? objectToEdit;
  const AddNewObject({super.key, this.objectToEdit});

  @override
  ConsumerState<AddNewObject> createState() => _AddNewObjectState();
}

class _AddNewObjectState extends ConsumerState<AddNewObject> {
  final _formKey = GlobalKey<FormState>();
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
    _categories.add(AppConstants.createCustomCategoryOption);

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

  void _saveObject() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String newCategory = _selectedCategory ?? '';
    if (_selectedCategory == AppConstants.createCustomCategoryOption) {
      newCategory = _customCategoryController.text.trim();
      final added =
          ref.read(customCategoriesProvider.notifier).addCategory(newCategory);
      if (added) {
        AppSnackBar.showInfo(context, 'Category "$newCategory" added.');
      }
    }

    final name = _nameController.text.trim();
    final objectId = widget.objectToEdit?.id ?? const Uuid().v4();
    final imagePath = _selectedImagePath;

    final savedObject = SpaceObject(
      id: objectId,
      name: name,
      category: newCategory,
      description: _descriptionController.text.trim(),
      imagePath: imagePath,
      notes: _notesController.text.trim(),
      isFavorite: widget.objectToEdit?.isFavorite ?? false,
    );

    if (widget.objectToEdit != null) {
      final old = widget.objectToEdit!;
      final hasChanges = old.name != name ||
          old.category != newCategory ||
          old.description != _descriptionController.text.trim() ||
          old.notes != _notesController.text.trim() ||
          old.imagePath != imagePath;

      if (!hasChanges) {
        Navigator.pop(context);
        return;
      }

      ref.read(spaceObjectsProvider.notifier).updateObject(savedObject);
      AppSnackBar.showSuccess(context, 'Object "$name" was updated!');
      Navigator.pop(context);
    } else {
      ref.read(spaceObjectsProvider.notifier).addObject(savedObject);
      AppSnackBar.showSuccess(context, 'New object "$name" has been created.');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.objectToEdit != null
            ? "Edit Space Object"
            : "Add New Space Object"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ObjectImagePicker(
              imagePath: _selectedImagePath,
              category: _selectedCategory ?? '',
              onImageSelected: (path) {
                setState(() {
                  _selectedImagePath = path;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              maxLength: 35,
              validator: (val) {
                final trimmed = val?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Please enter a space object name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Space object name",
                hintText: "Earth C-137 / Asgard - home of Thor",
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              initialValue: _selectedCategory,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
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
            if (_selectedCategory ==
                AppConstants.createCustomCategoryOption) ...[
              const SizedBox(height: 16),
              TextFormField(
                autofocus: true,
                controller: _customCategoryController,
                maxLength: 35,
                validator: (val) {
                  if (_selectedCategory ==
                      AppConstants.createCustomCategoryOption) {
                    final trimmed = val?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Please enter a custom category name';
                    }
                    if (trimmed == AppConstants.createCustomCategoryOption) {
                      return 'This category name is reserved';
                    }
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Enter custom category name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
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
            TextFormField(
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
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _saveObject,
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
                onPressed: _saveObject,
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
      ),
    );
  }
}
