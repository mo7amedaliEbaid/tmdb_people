import '../../data/models/person_model.dart';
import '../../data/repositories/person_repository.dart';

class GetCachedPopularPeople {
  final PersonRepository repository;
  GetCachedPopularPeople(this.repository);

  Future<List<PersonModel>> call() async {
    return repository.getCachedPopularPeople();
  }
}
