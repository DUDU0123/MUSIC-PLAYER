// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPlayedModelAdapter extends TypeAdapter<RecentlyPlayedModel> {
  @override
  final int typeId = 4;

  @override
  RecentlyPlayedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayedModel(
      id: fields[0] as int?,
      recentlyPlayedSongsList: (fields[1] as List).cast<AllMusicsModel>(),
      dateTimeAdded: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recentlyPlayedSongsList)
      ..writeByte(2)
      ..write(obj.dateTimeAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPlayedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
