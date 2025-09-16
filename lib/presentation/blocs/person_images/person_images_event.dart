part of 'person_images_bloc.dart';

abstract class PersonImagesEvent {}

class FetchPersonImages extends PersonImagesEvent {
  final int personId;
  FetchPersonImages({required this.personId});
}