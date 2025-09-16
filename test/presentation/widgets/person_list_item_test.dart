import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/presentation/widgets/person_list_item.dart';

void main() {
  group('PersonListItem', () {
    testWidgets('should display person name and profile image', (
      WidgetTester tester,
    ) async {
      // Arrange
      final person = PersonModel(
        id: 123,
        name: 'John Doe',
        profilePath: '/profile.jpg',
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(body: PersonListItem(person: person)),
          ),
        ),
      );

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Actor'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display placeholder icon when no profile image', (
      WidgetTester tester,
    ) async {
      // Arrange
      final person = PersonModel(id: 123, name: 'Jane Doe', profilePath: null);

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(body: PersonListItem(person: person)),
          ),
        ),
      );

      // Assert
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should navigate to person details when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final person = PersonModel(
        id: 123,
        name: 'John Doe',
        profilePath: '/profile.jpg',
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) =>
                      Scaffold(body: PersonListItem(person: person)),
                ),
                GoRoute(
                  path: '/person/:id',
                  builder: (context, state) => Scaffold(
                    body: Text('Person Details: ${state.pathParameters['id']}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PersonListItem));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Person Details: 123'), findsOneWidget);
    });

    testWidgets('should handle long names with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      final person = PersonModel(
        id: 123,
        name: 'Very Long Name That Should Be Truncated With Ellipsis',
        profilePath: '/profile.jpg',
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(body: PersonListItem(person: person)),
          ),
        ),
      );

      // Assert
      expect(
        find.text('Very Long Name That Should Be Truncated With Ellipsis'),
        findsOneWidget,
      );
      // The text should be truncated due to maxLines: 2 and overflow: TextOverflow.ellipsis
    });
  });
}
