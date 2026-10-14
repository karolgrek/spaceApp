import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/ui/widgets/apod/daily_picture_banner.dart';

void main() {
  testWidgets('DailyPictureBanner smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: DailyPictureBanner(),
          ),
        ),
      ),
    );

    expect(find.byType(DailyPictureBanner), findsOneWidget);
  });
}
