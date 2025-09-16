import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/presentation/blocs/popular_persons/popular_people_bloc.dart';
import 'package:tmdb/presentation/screens/home.dart';

class MockPopularPeopleBloc
    extends MockBloc<PopularPeopleEvent, PopularPeopleState>
    implements PopularPeopleBloc {}

@GenerateMocks([MockPopularPeopleBloc])
void main() {
  group('HomeScreen Widget Tests', () {
    late MockPopularPeopleBloc mockBloc;

    setUp(() {
      mockBloc = MockPopularPeopleBloc();
    });

    Widget createTestWidget() {
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => MaterialApp(
          home: BlocProvider<PopularPeopleBloc>.value(
            value: mockBloc,
            child: const HomeScreen(),
          ),
        ),
      );
    }

    testWidgets('should display loading indicator initially', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([PopularPeopleLoading()]),
        initialState: PopularPeopleLoading(),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display people list when loaded', (
      WidgetTester tester,
    ) async {
      final people = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
      ];

      whenListen(
        mockBloc,
        Stream.fromIterable([
          PopularPeopleLoading(),
          PopularPeopleLoaded(people: people, hasReachedMax: true),
        ]),
        initialState: PopularPeopleLoading(),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display error message when error occurs', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          PopularPeopleLoading(),
          PopularPeopleError(message: 'API Error'),
        ]),
        initialState: PopularPeopleLoading(),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Error: API Error'), findsOneWidget);
      // You should have a retry button in your UI
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display loading indicator for pagination', (
      WidgetTester tester,
    ) async {
      final people = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
      ];

      whenListen(
        mockBloc,
        Stream.fromIterable([
          PopularPeopleLoaded(people: people, hasReachedMax: false),
        ]),
        initialState: PopularPeopleLoaded(people: people, hasReachedMax: false),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Simulate scroll
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
