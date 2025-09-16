// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonImageModelAdapter extends TypeAdapter<PersonImageModel> {
  @override
  final int typeId = 2;

  @override
  PersonImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonImageModel(
      aspectRatio: fields[0] as double,
      height: fields[1] as int,
      iso6391: fields[2] as String?,
      filePath: fields[3] as String,
      voteAverage: fields[4] as double,
      voteCount: fields[5] as int,
      width: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PersonImageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.aspectRatio)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.iso6391)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.voteCount)
      ..writeByte(6)
      ..write(obj.width);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
