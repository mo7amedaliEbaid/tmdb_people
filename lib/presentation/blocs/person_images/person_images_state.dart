part of 'person_images_bloc.dart';

abstract class PersonImagesState extends Equatable {
  const PersonImagesState();

  @override
  List<Object?> get props => [];
}

class PersonImagesInitial extends PersonImagesState {
  const PersonImagesInitial();
}

class PersonImagesLoading extends PersonImagesState {
  const PersonImagesLoading();
}

class PersonImagesLoaded extends PersonImagesState {
  final List<PersonImage> images;
  
  const PersonImagesLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class PersonImagesError extends PersonImagesState {
  final String message;
  
  const PersonImagesError({required this.message});

  @override
  List<Object?> get props => [message];
}