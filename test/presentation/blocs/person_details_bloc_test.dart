import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/core/errors.dart';
import 'package:tmdb/data/models/person_details_model.dart';
import 'package:tmdb/domain/use_cases/get_cached_person_details.dart';
import 'package:tmdb/domain/use_cases/get_person_details.dart';
import 'package:tmdb/presentation/blocs/person_details/person_details_bloc.dart';

import 'person_details_bloc_test.mocks.dart';

@GenerateMocks([GetPersonDetails, GetCachedPersonDetails])
void main() {
  group('PersonDetailsBloc', () {
    late PersonDetailsBloc bloc;
    late MockGetPersonDetails mockGetPersonDetails;
    late MockGetCachedPersonDetails mockGetCachedPersonDetails;

    setUp(() {
      mockGetPersonDetails = MockGetPersonDetails();
      mockGetCachedPersonDetails = MockGetCachedPersonDetails();
      bloc = PersonDetailsBloc(
        getPersonDetails: mockGetPersonDetails,
        getCachedPersonDetails: mockGetCachedPersonDetails,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be PersonDetailsInitial', () {
      expect(bloc.state, equals(PersonDetailsInitial()));
    });

    group('FetchPersonDetails', () {
      final personDetails = PersonDetailsModel(
        id: 123,
        name: 'John Doe',
        biography: 'Great actor',
        gender: 2,
        popularity: 85.5,
      );

      blocTest<PersonDetailsBloc, PersonDetailsState>(
        'emits [PersonDetailsLoading, PersonDetailsLoaded] when successful',
        build: () {
          when(
            mockGetPersonDetails.call(123),
          ).thenAnswer((_) async => personDetails);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonDetails(personId: 123)),
        expect: () => [
          PersonDetailsLoading(),
          PersonDetailsLoaded(details: personDetails),
        ],
        verify: (_) {
          verify(mockGetPersonDetails.call(123)).called(1);
        },
      );

      blocTest<PersonDetailsBloc, PersonDetailsState>(
        'emits [PersonDetailsLoading, PersonDetailsLoaded] with cached data on NetworkException',
        build: () {
          when(
            mockGetPersonDetails.call(123),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPersonDetails.call(123),
          ).thenAnswer((_) async => personDetails);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonDetails(personId: 123)),
        expect: () => [
          PersonDetailsLoading(),
          PersonDetailsLoaded(details: personDetails),
        ],
        verify: (_) {
          verify(mockGetPersonDetails.call(123)).called(1);
          verify(mockGetCachedPersonDetails.call(123)).called(1);
        },
      );

      blocTest<PersonDetailsBloc, PersonDetailsState>(
        'emits [PersonDetailsLoading, PersonDetailsError] when no cached data on NetworkException',
        build: () {
          when(
            mockGetPersonDetails.call(123),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPersonDetails.call(123),
          ).thenAnswer((_) async => null);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonDetails(personId: 123)),
        expect: () => [
          PersonDetailsLoading(),
          PersonDetailsError(message: 'ApiException: No internet'),
        ],
        verify: (_) {
          verify(mockGetPersonDetails.call(123)).called(1);
          verify(mockGetCachedPersonDetails.call(123)).called(1);
        },
      );

      blocTest<PersonDetailsBloc, PersonDetailsState>(
        'emits [PersonDetailsLoading, PersonDetailsError] on ApiException',
        build: () {
          when(
            mockGetPersonDetails.call(123),
          ).thenThrow(ApiException('API Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonDetails(personId: 123)),
        expect: () => [
          PersonDetailsLoading(),
          PersonDetailsError(message: 'ApiException: API Error'),
        ],
        verify: (_) {
          verify(mockGetPersonDetails.call(123)).called(1);
        },
      );

      blocTest<PersonDetailsBloc, PersonDetailsState>(
        'emits [PersonDetailsLoading, PersonDetailsError] on generic exception',
        build: () {
          when(
            mockGetPersonDetails.call(123),
          ).thenThrow(Exception('Generic Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonDetails(personId: 123)),
        expect: () => [
          PersonDetailsLoading(),
          PersonDetailsError(message: 'Exception: Generic Error'),
        ],
        verify: (_) {
          verify(mockGetPersonDetails.call(123)).called(1);
        },
      );
    });
  });
}
