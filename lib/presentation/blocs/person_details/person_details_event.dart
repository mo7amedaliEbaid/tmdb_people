part of 'person_details_bloc.dart';

abstract class PersonDetailsEvent {}

class FetchPersonDetails extends PersonDetailsEvent {
  final int personId;
  FetchPersonDetails({required this.personId});
}