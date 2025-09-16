import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../data/data_sources/tmdb_api.dart';
import '../data/repositories/person_details_repository.dart';
import '../data/repositories/person_repository.dart';
import '../domain/use_cases/get_cached_person_details.dart';
import '../domain/use_cases/get_cached_person_images.dart';
import '../domain/use_cases/get_cached_popular_people.dart';
import '../domain/use_cases/get_person_details.dart';
import '../domain/use_cases/get_person_images.dart';
import '../domain/use_cases/get_popular_people.dart';
import '../presentation/blocs/person_details/person_details_bloc.dart';
import '../presentation/blocs/person_images/person_images_bloc.dart';
import '../presentation/blocs/popular_persons/popular_people_bloc.dart';
import '../presentation/screens/home.dart';
import '../presentation/screens/image_viewer.dart';
import '../presentation/screens/person_details.dart';

class AppRouter {
  static GoRouter createRouter() {
    final tmdbApi = TmdbApi();
    final cacheBox = Hive.box('cache');
    final personRepository = PersonRepository(
      tmdbApi: tmdbApi,
      cacheBox: cacheBox,
    );
    final personDetailsRepository = PersonDetailsRepository(
      tmdbApi: tmdbApi,
      cacheBox: cacheBox,
    );

    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => PopularPeopleBloc(
                getPopularPeople: GetPopularPeople(personRepository),
                getCachedPopularPeople: GetCachedPopularPeople(
                  personRepository,
                ),
              ),
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/person/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => PersonDetailsBloc(
                    getPersonDetails: GetPersonDetails(
                      repository: personDetailsRepository,
                    ),
                    getCachedPersonDetails: GetCachedPersonDetails(
                      repository: personDetailsRepository,
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => PersonImagesBloc(
                    getPersonImages: GetPersonImages(
                      repository: personDetailsRepository,
                    ),
                    getCachedPersonImages: GetCachedPersonImages(
                      repository: personDetailsRepository,
                    ),
                  ),
                ),
              ],
              child: PersonDetailsScreen(personId: id),
            );
          },
        ),
        GoRoute(
          path: '/image',
          builder: (context, state) {
            final imageUrl = state.queryParameters['url']!;
            return ImageViewerScreen(imageUrl: imageUrl);
          },
        ),
      ],
    );
  }
}
