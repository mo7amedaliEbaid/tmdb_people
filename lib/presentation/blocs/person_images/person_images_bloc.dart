import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors.dart';
import '../../../domain/entities/person_image.dart';
import '../../../domain/use_cases/get_cached_person_images.dart';
import '../../../domain/use_cases/get_person_images.dart';

part 'person_images_event.dart';
part 'person_images_state.dart';

class PersonImagesBloc extends Bloc<PersonImagesEvent, PersonImagesState> {
  final GetPersonImages getPersonImages;
  final GetCachedPersonImages getCachedPersonImages;

  PersonImagesBloc({
    required this.getPersonImages,
    required this.getCachedPersonImages,
  }) : super(PersonImagesInitial()) {
    on<FetchPersonImages>(_onFetchPersonImages);
  }

  Future<void> _onFetchPersonImages(
    FetchPersonImages event,
    Emitter<PersonImagesState> emit,
  ) async {
    emit(PersonImagesLoading());
    try {
      final images = await getPersonImages.call(event.personId);
      emit(PersonImagesLoaded(images: images));
    } on NetworkException catch (e) {
      final cached = await getCachedPersonImages.call(event.personId);
      if (cached.isNotEmpty) {
        emit(PersonImagesLoaded(images: cached));
      } else {
        emit(PersonImagesError(message: e.toString()));
      }
    } on ApiException catch (e) {
      emit(PersonImagesError(message: e.toString()));
    } catch (e) {
      emit(PersonImagesError(message: e.toString()));
    }
  }
}