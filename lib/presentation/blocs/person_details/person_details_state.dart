part of 'person_details_bloc.dart';

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();

  @override
  List<Object?> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {
  const PersonDetailsInitial();
}

class PersonDetailsLoading extends PersonDetailsState {
  const PersonDetailsLoading();
}

class PersonDetailsLoaded extends PersonDetailsState {
  final PersonDetails details;
  
  const PersonDetailsLoaded({required this.details});

  @override
  List<Object?> get props => [details];
}

class PersonDetailsError extends PersonDetailsState {
  final String message;
  
  const PersonDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}