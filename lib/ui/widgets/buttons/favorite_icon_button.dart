import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';

class FavoriteIconButton extends ConsumerWidget {
  final SpaceObject spaceObject;

  const FavoriteIconButton({
    super.key,
    required this.spaceObject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = spaceObject.isFavorite;

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : Colors.white,
      ),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () {
        final isFav = ref
            .read(spaceObjectsProvider.notifier)
            .toggleFavorite(spaceObject.id);

        if (isFav) {
          AppSnackBar.showSuccess(
            context,
            'Added to favorites',
            icon: Icons.favorite,
          );
        } else {
          AppSnackBar.showInfo(
            context,
            'Removed from favorites',
            icon: Icons.favorite_border,
          );
        }
      },
    );
  }
}
