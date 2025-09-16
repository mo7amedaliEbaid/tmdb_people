import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors.dart';
import '../../../domain/entities/person_details.dart';
import '../../../domain/use_cases/get_cached_person_details.dart';
import '../../../domain/use_cases/get_person_details.dart';

part 'person_details_event.dart';
part 'person_details_state.dart';

class PersonDetailsBloc extends Bloc<PersonDetailsEvent, PersonDetailsState> {
  final GetPersonDetails getPersonDetails;
  final GetCachedPersonDetails getCachedPersonDetails;

  PersonDetailsBloc({
    required this.getPersonDetails,
    required this.getCachedPersonDetails,
  }) : super(PersonDetailsInitial()) {
    on<FetchPersonDetails>(_onFetchPersonDetails);
  }

  Future<void> _onFetchPersonDetails(
    FetchPersonDetails event,
    Emitter<PersonDetailsState> emit,
  ) async {
    emit(PersonDetailsLoading());
    try {
      final details = await getPersonDetails.call(event.personId);
      emit(PersonDetailsLoaded(details: details));
    } on NetworkException catch (e) {
      final cached = await getCachedPersonDetails.call(event.personId);
      if (cached != null) {
        emit(PersonDetailsLoaded(details: cached));
      } else {
        emit(PersonDetailsError(message: e.toString()));
      }
    } on ApiException catch (e) {
      emit(PersonDetailsError(message: e.toString()));
    } catch (e) {
      emit(PersonDetailsError(message: e.toString()));
    }
  }
}