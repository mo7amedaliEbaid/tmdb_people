part of 'save_image_cubit.dart';

abstract class SaveImageState extends Equatable {
  const SaveImageState();

  @override
  List<Object?> get props => [];
}

class SaveImageInitial extends SaveImageState {}

class SaveImageLoading extends SaveImageState {}

class SaveImageSuccess extends SaveImageState {
  final String result;

  const SaveImageSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class SaveImageFailure extends SaveImageState {
  final String error;

  const SaveImageFailure(this.error);

  @override
  List<Object?> get props => [error];
}
