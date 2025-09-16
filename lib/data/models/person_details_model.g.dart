// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonDetailsModelAdapter extends TypeAdapter<PersonDetailsModel> {
  @override
  final int typeId = 1;

  @override
  PersonDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonDetailsModel(
      id: fields[0] as int,
      name: fields[1] as String,
      biography: fields[2] as String?,
      birthday: fields[3] as String?,
      deathday: fields[4] as String?,
      gender: fields[5] as int,
      homepage: fields[6] as String?,
      imdbId: fields[7] as String?,
      knownForDepartment: fields[8] as String?,
      placeOfBirth: fields[9] as String?,
      popularity: fields[10] as double,
      profilePath: fields[11] as String?,
      alsoKnownAs: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PersonDetailsModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.biography)
      ..writeByte(3)
      ..write(obj.birthday)
      ..writeByte(4)
      ..write(obj.deathday)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.homepage)
      ..writeByte(7)
      ..write(obj.imdbId)
      ..writeByte(8)
      ..write(obj.knownForDepartment)
      ..writeByte(9)
      ..write(obj.placeOfBirth)
      ..writeByte(10)
      ..write(obj.popularity)
      ..writeByte(11)
      ..write(obj.profilePath)
      ..writeByte(12)
      ..write(obj.alsoKnownAs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
