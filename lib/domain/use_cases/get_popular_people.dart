import '../../data/models/person_model.dart';
import '../../data/repositories/person_repository.dart';

class GetPopularPeople {
  final PersonRepository repository;
  GetPopularPeople(this.repository);

  Future<List<PersonModel>> call({int page = 1}) async {
    return repository.getPopularPeople(page: page);
  }
}
