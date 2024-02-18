import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'allmusics_model.g.dart';

@HiveType(typeId: 1)
class AllMusicsModel extends HiveObject {
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

  AllMusicsModel({
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

  factory AllMusicsModel.fromSongModel(SongModel songModel) {
    return AllMusicsModel(
      id: songModel.id,
      musicName: songModel.displayNameWOExt,
      musicArtistName: songModel.artist ?? "Unknown Artist",
      musicAlbumName: songModel.album ?? "Unknown Album",
      musicFormat: songModel.fileExtension,
      musicPathInDevice: songModel.data,
      musicUri: songModel.uri!,
      musicFileSize: songModel.size,
      musicSelected: false,
    );
  }
  // final String musicFileSize;
  // final String musicCoverImage;
}
