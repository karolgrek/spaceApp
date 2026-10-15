import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/screens/hp_notebook_screen.dart';
import 'package:space_app/ui/screens/object_detail_screen.dart';
import 'package:space_app/ui/widgets/category/category_filter_dialog.dart';
import 'package:space_app/ui/widgets/object/object_card.dart';

import 'helpers/test_notifiers.dart';


void main() {
  group('Favorites UI & Integration Tests', () {
    testWidgets(
        'ObjectCard displays favorite heart badge when isFavorite is true',
        (tester) async {
      final favObject = SpaceObject(
        id: '1',
        name: 'Earth',
        category: 'Planet',
        description: 'Our world',
        imagePath: '',
        notes: '',
        isFavorite: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ObjectCard(spaceObject: favObject),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets(
        'ObjectCard does not display heart badge when isFavorite is false',
        (tester) async {
      final normalObject = SpaceObject(
        id: '2',
        name: 'Mars',
        category: 'Planet',
        description: 'Red planet',
        imagePath: '',
        notes: '',
        isFavorite: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ObjectCard(spaceObject: normalObject),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('ObjectDetailScreen toggles favorite on heart tap',
        (tester) async {
      final testObject = SpaceObject(
        id: 'detail_fav_1',
        name: 'Jupiter',
        category: 'Planet',
        description: 'Gas giant',
        imagePath: '',
        notes: '',
        isFavorite: false,
      );

      final container = ProviderContainer(
        overrides: [
          spaceObjectsProvider.overrideWith(
            () => TestSpaceObjectsNotifier([testObject]),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ObjectDetailScreen(spaceObject: testObject),
          ),
        ),
      );

      // Initially outlined white heart in AppBar
      final appBarHeart = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.favorite_border),
      );
      expect(appBarHeart, findsOneWidget);

      // Tap heart in AppBar to add to favorites
      await tester.tap(appBarHeart);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final appBarFilledHeart = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.favorite),
      );
      expect(appBarFilledHeart, findsOneWidget);
      expect(find.text('Added to favorites'), findsOneWidget);

      // Provider state is updated
      expect(
        container
            .read(spaceObjectsProvider)
            .firstWhere((o) => o.id == 'detail_fav_1')
            .isFavorite,
        isTrue,
      );

      // Tap again to remove from favorites
      await tester.tap(appBarFilledHeart);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(appBarHeart, findsOneWidget);
      expect(find.text('Removed from favorites'), findsOneWidget);
      expect(
        container
            .read(spaceObjectsProvider)
            .firstWhere((o) => o.id == 'detail_fav_1')
            .isFavorite,
        isFalse,
      );

      // Fast-forward past snackbar timeout
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets(
        'CategoryFilterDialog hides Favorites tile when no favorites exist',
        (tester) async {
      final nonFav = SpaceObject(
        id: 'nf_1',
        name: 'Neptune',
        category: 'Planet',
        description: '',
        imagePath: '',
        notes: '',
        isFavorite: false,
      );

      final container = ProviderContainer(
        overrides: [
          spaceObjectsProvider.overrideWith(
            () => TestSpaceObjectsNotifier([nonFav]),
          ),
          customCategoriesProvider.overrideWith(
            () => TestCategoriesNotifier(['Planet', 'Star']),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: CategoryFilterDialog(),
            ),
          ),
        ),
      );

      // No favorites exist -> Favorites tile hidden
      expect(find.text('Favorites'), findsNothing);
      expect(find.text('Planet'), findsOneWidget);
    });

    testWidgets(
        'CategoryFilterDialog shows Favorites tile and toggles filter when favorites exist',
        (tester) async {
      final favObj = SpaceObject(
        id: 'fav_1',
        name: 'Saturn',
        category: 'Planet',
        description: '',
        imagePath: '',
        notes: '',
        isFavorite: true,
      );

      final container = ProviderContainer(
        overrides: [
          spaceObjectsProvider.overrideWith(
            () => TestSpaceObjectsNotifier([favObj]),
          ),
          customCategoriesProvider.overrideWith(
            () => TestCategoriesNotifier(['Planet', 'Star']),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: CategoryFilterDialog(),
            ),
          ),
        ),
      );

      expect(find.text('Favorites'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Toggle Favorites checkbox
      await tester.tap(find.text('Favorites'));
      await tester.pump();

      expect(container.read(favoritesFilterProvider), isTrue);
    });

    testWidgets(
        'auto-resets favorites filter when the last favorite object is removed',
        (tester) async {
      final favObj = SpaceObject(
        id: 'sole_fav',
        name: 'Pluto',
        category: 'Dwarf Planet',
        description: 'Small world',
        imagePath: '',
        notes: '',
        isFavorite: true,
      );

      final container = ProviderContainer(
        overrides: [
          spaceObjectsProvider.overrideWith(
            () => TestSpaceObjectsNotifier([favObj]),
          ),
          favoritesFilterProvider.overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);

      // Initially filter is active
      expect(container.read(favoritesFilterProvider), isTrue);

      // Now toggle the sole favorite to false
      container.read(spaceObjectsProvider.notifier).toggleFavorite('sole_fav');

      // The filter should automatically reset to false
      expect(container.read(favoritesFilterProvider), isFalse);
    });

    testWidgets(
        'NotebookScreen shows all objects when favorites filter was active but hasFavorites is false',
        (tester) async {
      final normalObj = SpaceObject(
        id: 'normal_1',
        name: 'Earth',
        category: 'Planet',
        description: '',
        imagePath: '',
        notes: '',
        isFavorite: false,
      );

      final container = ProviderContainer(
        overrides: [
          spaceObjectsProvider.overrideWith(
            () => TestSpaceObjectsNotifier([normalObj]),
          ),
          favoritesFilterProvider.overrideWith((ref) => true),
          customCategoriesProvider.overrideWith(
            () => TestCategoriesNotifier(['Planet']),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: NotebookScreen(),
          ),
        ),
      );

      // Since hasFavorites is false, Earth must still be visible and not filtered out!
      expect(find.text('Earth'), findsOneWidget);
    });
  });
}
