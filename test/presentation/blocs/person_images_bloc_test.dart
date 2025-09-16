import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb/core/errors.dart';
import 'package:tmdb/data/models/person_image_model.dart';
import 'package:tmdb/domain/use_cases/get_cached_person_images.dart';
import 'package:tmdb/domain/use_cases/get_person_images.dart';
import 'package:tmdb/presentation/blocs/person_images/person_images_bloc.dart';

import 'person_images_bloc_test.mocks.dart';

@GenerateMocks([GetPersonImages, GetCachedPersonImages])
void main() {
  group('PersonImagesBloc', () {
    late PersonImagesBloc bloc;
    late MockGetPersonImages mockGetPersonImages;
    late MockGetCachedPersonImages mockGetCachedPersonImages;

    setUp(() {
      mockGetPersonImages = MockGetPersonImages();
      mockGetCachedPersonImages = MockGetCachedPersonImages();
      bloc = PersonImagesBloc(
        getPersonImages: mockGetPersonImages,
        getCachedPersonImages: mockGetCachedPersonImages,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be PersonImagesInitial', () {
      expect(bloc.state, equals(PersonImagesInitial()));
    });

    group('FetchPersonImages', () {
      final images = [
        PersonImageModel(
          aspectRatio: 0.667,
          height: 3000,
          iso6391: null,
          filePath: '/image1.jpg',
          voteAverage: 5.5,
          voteCount: 100,
          width: 2000,
        ),
        PersonImageModel(
          aspectRatio: 1.0,
          height: 1500,
          iso6391: 'en',
          filePath: '/image2.jpg',
          voteAverage: 7.2,
          voteCount: 50,
          width: 1500,
        ),
      ];

      blocTest<PersonImagesBloc, PersonImagesState>(
        'emits [PersonImagesLoading, PersonImagesLoaded] when successful',
        build: () {
          when(mockGetPersonImages.call(123)).thenAnswer((_) async => images);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonImages(personId: 123)),
        expect: () => [
          PersonImagesLoading(),
          PersonImagesLoaded(images: images),
        ],
        verify: (_) {
          verify(mockGetPersonImages.call(123)).called(1);
        },
      );

      blocTest<PersonImagesBloc, PersonImagesState>(
        'emits [PersonImagesLoading, PersonImagesLoaded] with cached data on NetworkException',
        build: () {
          when(
            mockGetPersonImages.call(123),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPersonImages.call(123),
          ).thenAnswer((_) async => images);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonImages(personId: 123)),
        expect: () => [
          PersonImagesLoading(),
          PersonImagesLoaded(images: images),
        ],
        verify: (_) {
          verify(mockGetPersonImages.call(123)).called(1);
          verify(mockGetCachedPersonImages.call(123)).called(1);
        },
      );

      blocTest<PersonImagesBloc, PersonImagesState>(
        'emits [PersonImagesLoading, PersonImagesError] when no cached data on NetworkException',
        build: () {
          when(
            mockGetPersonImages.call(123),
          ).thenThrow(NetworkException('No internet'));
          when(
            mockGetCachedPersonImages.call(123),
          ).thenAnswer((_) async => <PersonImageModel>[]);
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonImages(personId: 123)),
        expect: () => [
          PersonImagesLoading(),
          PersonImagesError(message: 'ApiException: No internet'),
        ],
        verify: (_) {
          verify(mockGetPersonImages.call(123)).called(1);
          verify(mockGetCachedPersonImages.call(123)).called(1);
        },
      );

      blocTest<PersonImagesBloc, PersonImagesState>(
        'emits [PersonImagesLoading, PersonImagesError] on ApiException',
        build: () {
          when(
            mockGetPersonImages.call(123),
          ).thenThrow(ApiException('API Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonImages(personId: 123)),
        expect: () => [
          PersonImagesLoading(),
          PersonImagesError(message: 'ApiException: API Error'),
        ],
        verify: (_) {
          verify(mockGetPersonImages.call(123)).called(1);
        },
      );

      blocTest<PersonImagesBloc, PersonImagesState>(
        'emits [PersonImagesLoading, PersonImagesError] on generic exception',
        build: () {
          when(
            mockGetPersonImages.call(123),
          ).thenThrow(Exception('Generic Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPersonImages(personId: 123)),
        expect: () => [
          PersonImagesLoading(),
          PersonImagesError(message: 'Exception: Generic Error'),
        ],
        verify: (_) {
          verify(mockGetPersonImages.call(123)).called(1);
        },
      );
    });
  });
}
