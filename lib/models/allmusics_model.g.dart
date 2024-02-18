// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allmusics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllMusicsModelAdapter extends TypeAdapter<AllMusicsModel> {
  @override
  final int typeId = 1;

  @override
  AllMusicsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllMusicsModel(
      id: fields[0] as int,
      musicName: fields[1] as String,
      musicAlbumName: fields[2] as String,
      musicArtistName: fields[3] as String,
      musicPathInDevice: fields[4] as String,
      musicFormat: fields[5] as String,
      musicUri: fields[6] as String,
      musicFileSize: fields[7] as int,
      musicSelected: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AllMusicsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.musicName)
      ..writeByte(2)
      ..write(obj.musicAlbumName)
      ..writeByte(3)
      ..write(obj.musicArtistName)
      ..writeByte(4)
      ..write(obj.musicPathInDevice)
      ..writeByte(5)
      ..write(obj.musicFormat)
      ..writeByte(6)
      ..write(obj.musicUri)
      ..writeByte(7)
      ..write(obj.musicFileSize)
      ..writeByte(8)
      ..write(obj.musicSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllMusicsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
