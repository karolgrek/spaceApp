import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/space_object_provider.dart';

class FavoritesFilterTile extends ConsumerWidget {
  const FavoritesFilterTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesOnly = ref.watch(favoritesFilterProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          secondary: const Icon(
            Icons.favorite,
            color: Colors.redAccent,
            size: 20,
          ),
          title: const Text(
            'Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          value: favoritesOnly,
          onChanged: (bool? checked) {
            ref.read(favoritesFilterProvider.notifier).state = checked ?? false;
          },
        ),
        const Divider(),
      ],
    );
  }
}
