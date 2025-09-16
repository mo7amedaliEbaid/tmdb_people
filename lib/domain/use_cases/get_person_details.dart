import '../entities/person_details.dart';
import '../../data/repositories/person_details_repository.dart';

class GetPersonDetails {
  final PersonDetailsRepository repository;

  GetPersonDetails({required this.repository});

  Future<PersonDetails> call(int id) async {
    return await repository.getPersonDetails(id);
  }
}