import '../entities/person_image.dart';
import '../../data/repositories/person_details_repository.dart';

class GetPersonImages {
  final PersonDetailsRepository repository;

  GetPersonImages({required this.repository});

  Future<List<PersonImage>> call(int id) async {
    return await repository.getPersonImages(id);
  }
}