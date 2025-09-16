import '../entities/person_details.dart';
import '../../data/repositories/person_details_repository.dart';

class GetCachedPersonDetails {
  final PersonDetailsRepository repository;

  GetCachedPersonDetails({required this.repository});

  Future<PersonDetails?> call(int id) async {
    return await repository.getCachedPersonDetails(id);
  }
}
