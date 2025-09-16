import '../entities/person_image.dart';
import '../../data/repositories/person_details_repository.dart';

class GetCachedPersonImages {
  final PersonDetailsRepository repository;

  GetCachedPersonImages({required this.repository});

  Future<List<PersonImage>> call(int id) async {
    return await repository.getCachedPersonImages(id);
  }
}
