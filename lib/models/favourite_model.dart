import 'package:hive_flutter/hive_flutter.dart';
part 'favourite_model.g.dart';

@HiveType(typeId: 3)
class FavoriteModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  final String musicName;
  @HiveField(2)
  final String musicAlbumName;
  @HiveField(3)
  final String musicArtistName;
  @HiveField(4)
  final String musicPathInDevice;
  @HiveField(5)
  final String musicFormat;
  @HiveField(6)
  final String musicUri;
  @HiveField(7)
  final int musicFileSize;
  @HiveField(8)
  bool? musicSelected;
  FavoriteModel({
    required this.id,
    required this.musicName,
    required this.musicAlbumName,
    required this.musicArtistName,
    required this.musicPathInDevice,
    required this.musicFormat,
    required this.musicUri,
    required this.musicFileSize,
    this.musicSelected,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
