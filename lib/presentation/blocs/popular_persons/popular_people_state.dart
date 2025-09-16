part of 'popular_people_bloc.dart';

abstract class PopularPeopleState extends Equatable {
  const PopularPeopleState();

  @override
  List<Object?> get props => [];
}

class PopularPeopleInitial extends PopularPeopleState {
  const PopularPeopleInitial();
}

class PopularPeopleLoading extends PopularPeopleState {
  const PopularPeopleLoading();
}

class PopularPeopleLoaded extends PopularPeopleState {
  final List<PersonModel> people;
  final bool hasReachedMax;
  
  const PopularPeopleLoaded({required this.people, this.hasReachedMax = false});

  @override
  List<Object?> get props => [people, hasReachedMax];
}

class PopularPeopleError extends PopularPeopleState {
  final String message;
  
  const PopularPeopleError({required this.message});

  @override
  List<Object?> get props => [message];
}
