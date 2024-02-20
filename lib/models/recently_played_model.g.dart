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
      recentlyPlayedSongsList: (fields[0] as List).cast<AllMusicsModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recentlyPlayedSongsList);
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
