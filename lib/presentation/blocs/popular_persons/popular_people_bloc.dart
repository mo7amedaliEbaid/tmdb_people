import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors.dart';
import '../../../data/models/person_model.dart';
import '../../../domain/use_cases/get_cached_popular_people.dart';
import '../../../domain/use_cases/get_popular_people.dart';

part 'popular_people_event.dart';
part 'popular_people_state.dart';

class PopularPeopleBloc extends Bloc<PopularPeopleEvent, PopularPeopleState> {
  final GetPopularPeople getPopularPeople;
  final GetCachedPopularPeople getCachedPopularPeople;

  int _page = 1;
  bool _isFetching = false;

  PopularPeopleBloc({
    required this.getPopularPeople,
    required this.getCachedPopularPeople,
  }) : super(PopularPeopleInitial()) {
    on<FetchPopularPeople>(_onFetchPopularPeople);
    on<FetchMorePopularPeople>(_onFetchMorePopularPeople);
  }

  Future<void> _onFetchPopularPeople(
    FetchPopularPeople event,
    Emitter<PopularPeopleState> emit,
  ) async {
    emit(PopularPeopleLoading());
    try {
      _page = 1;
      final list = await getPopularPeople.call(page: _page);
      emit(PopularPeopleLoaded(people: list, hasReachedMax: list.isEmpty));
    } on NetworkException catch (e) {
      final cached = await getCachedPopularPeople.call();
      if (cached.isNotEmpty) {
        emit(PopularPeopleLoaded(people: cached, hasReachedMax: true));
      } else {
        emit(PopularPeopleError(message: e.toString()));
      }
    } on ApiException catch (e) {
      emit(PopularPeopleError(message: e.toString()));
    } catch (e) {
      emit(PopularPeopleError(message: e.toString()));
    }
  }

  Future<void> _onFetchMorePopularPeople(
    FetchMorePopularPeople event,
    Emitter<PopularPeopleState> emit,
  ) async {
    if (state is! PopularPeopleLoaded || _isFetching) return;

    _isFetching = true;
    _page += 1;

    try {
      final more = await getPopularPeople.call(page: _page);
      final current = (state as PopularPeopleLoaded).people;
      emit(
        PopularPeopleLoaded(
          people: List.of(current)..addAll(more),
          hasReachedMax: more.isEmpty,
        ),
      );
    } on NetworkException {
      emit(state); // keep old state if no internet
    } on ApiException catch (e) {
      emit(PopularPeopleError(message: e.toString()));
    } catch (e) {
      emit(PopularPeopleError(message: e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
