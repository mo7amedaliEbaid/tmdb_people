import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/core/errors.dart';
import 'package:tmdb/data/models/person_model.dart';
import 'package:tmdb/domain/use_cases/get_cached_popular_people.dart';
import 'package:tmdb/domain/use_cases/get_popular_people.dart';
import 'package:tmdb/presentation/blocs/popular_persons/popular_people_bloc.dart';

import 'popular_people_bloc_test.mocks.dart';

@GenerateMocks([GetPopularPeople, GetCachedPopularPeople])
void main() {
  group('PopularPeopleBloc', () {
    late PopularPeopleBloc bloc;
    late MockGetPopularPeople mockGetPopularPeople;
    late MockGetCachedPopularPeople mockGetCachedPopularPeople;

    setUp(() {
      mockGetPopularPeople = MockGetPopularPeople();
      mockGetCachedPopularPeople = MockGetCachedPopularPeople();
      bloc = PopularPeopleBloc(
        getPopularPeople: mockGetPopularPeople,
        getCachedPopularPeople: mockGetCachedPopularPeople,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be PopularPeopleInitial', () {
      expect(bloc.state, equals(PopularPeopleInitial()));
    });

    group('FetchPopularPeople', () {
      final people = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
        PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
      ];

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'emits [PopularPeopleLoading, PopularPeopleLoaded] when successful',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenAnswer((_) async => people);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPopularPeople()),
        expect: () => [
          PopularPeopleLoading(),
          PopularPeopleLoaded(people: people, hasReachedMax: false),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 1)).called(1);
        },
      );

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'emits [PopularPeopleLoading, PopularPeopleLoaded] with cached data on NetworkException',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPopularPeople.call(),
          ).thenAnswer((_) async => people);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPopularPeople()),
        expect: () => [
          PopularPeopleLoading(),
          PopularPeopleLoaded(people: people, hasReachedMax: true),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 1)).called(1);
          verify(mockGetCachedPopularPeople.call()).called(1);
        },
      );

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'emits [PopularPeopleLoading, PopularPeopleError] when no cached data on NetworkException',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPopularPeople.call(),
          ).thenAnswer((_) async => <PersonModel>[]);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPopularPeople()),
        expect: () => [
          PopularPeopleLoading(),
          PopularPeopleError(message: 'ApiException: No internet'),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 1)).called(1);
          verify(mockGetCachedPopularPeople.call()).called(1);
        },
      );

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'emits [PopularPeopleLoading, PopularPeopleError] on ApiException',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenThrow(ApiException('API Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPopularPeople()),
        expect: () => [
          PopularPeopleLoading(),
          PopularPeopleError(message: 'ApiException: API Error'),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 1)).called(1);
        },
      );
    });

    group('FetchMorePopularPeople', () {
      final initialPeople = [
        PersonModel(id: 1, name: 'John Doe', profilePath: '/john.jpg'),
      ];
      final morePeople = [
        PersonModel(id: 2, name: 'Jane Doe', profilePath: '/jane.jpg'),
      ];

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'emits [PopularPeopleLoaded] with more people when successful',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenAnswer((_) async => initialPeople);
          when(
            mockGetPopularPeople.call(page: 2),
          ).thenAnswer((_) async => morePeople);
          return bloc;
        },
        seed: () =>
            PopularPeopleLoaded(people: initialPeople, hasReachedMax: false),
        act: (bloc) => bloc.add(FetchMorePopularPeople()),
        expect: () => [
          PopularPeopleLoaded(
            people: [...initialPeople, ...morePeople],
            hasReachedMax: false,
          ),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 2)).called(1);
        },
      );

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'does not emit when state is not PopularPeopleLoaded',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenAnswer((_) async => initialPeople);
          return bloc;
        },
        seed: () => PopularPeopleLoading(),
        act: (bloc) => bloc.add(FetchMorePopularPeople()),
        expect: () => [],
        verify: (_) {
          verifyNever(mockGetPopularPeople.call(page: 2));
        },
      );

      blocTest<PopularPeopleBloc, PopularPeopleState>(
        'does not emit when already fetching',
        build: () {
          when(
            mockGetPopularPeople.call(page: 1),
          ).thenAnswer((_) async => initialPeople);
          when(
            mockGetPopularPeople.call(page: 2),
          ).thenAnswer((_) async => morePeople);
          when(
            mockGetPopularPeople.call(page: 3),
          ).thenAnswer((_) async => <PersonModel>[]);
          return bloc;
        },
        seed: () =>
            PopularPeopleLoaded(people: initialPeople, hasReachedMax: false),
        act: (bloc) {
          bloc.add(FetchMorePopularPeople());
          bloc.add(FetchMorePopularPeople()); // Second call should be ignored
        },
        expect: () => [
          PopularPeopleLoaded(
            people: [...initialPeople, ...morePeople],
            hasReachedMax: false,
          ),
          PopularPeopleLoaded(
            people: [...initialPeople, ...morePeople],
            hasReachedMax: true,
          ),
        ],
        verify: (_) {
          verify(mockGetPopularPeople.call(page: 2)).called(1);
        },
      );
    });
  });
}
