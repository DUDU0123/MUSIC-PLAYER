import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/constants/allsongslist.dart';
import 'package:music_player/controllers/all_music_controller.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/functions_default.dart';
import 'package:music_player/models/allmusics_model.dart';
import 'package:music_player/views/common_widgets/default_common_widget.dart';
import 'package:music_player/views/common_widgets/music_play_page_open.dart';
import 'package:music_player/views/common_widgets/music_tile_widget.dart';
import 'package:music_player/views/common_widgets/side_title_appbar_common.dart';
import 'package:music_player/views/common_widgets/text_widget_common.dart';
import 'package:music_player/views/enums/page_and_menu_type_enum.dart';

class AlbumSongListPage extends StatefulWidget {
  const AlbumSongListPage({
    super.key,
    required this.albumName,
    required this.albumSongs,
    required this.songModel,
  });
  final String albumName;
  final List<AllMusicsModel> albumSongs;
  final AllMusicsModel songModel;

  @override
  State<AlbumSongListPage> createState() => _AlbumSongListPageState();
}

class _AlbumSongListPageState extends State<AlbumSongListPage> {
  @override
  void initState() {
    AllMusicController.to.fetchAllAlbumMusicData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SideTitleAppBarCommon(
          onPressed: () {
            Navigator.pop(context);
          },
          appBarText: widget.albumName,
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: TextWidgetCommon(
                text: "Done",
                color: kRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
      body: widget.albumSongs.isEmpty
          ? const DefaultCommonWidget(text: "No songs available")
          : ValueListenableBuilder(
              valueListenable: AllFiles.files,
              builder: (BuildContext context, List<AllMusicsModel> songs,
                  Widget? _) {
                final List<AllMusicsModel> albumSongs = AllMusicController.to
                    .getSongsOfAlbum(songs, widget.albumName);
                return ListView.builder(
                  itemCount: albumSongs.length,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  itemBuilder: (context, index) {
                    return MusicTileWidget(
                      onTap: () {
                        AudioController.to.isPlaying.value = true;
                        AudioController.to.playSong(albumSongs[index]);
                        musicPlayPageOpenPage(
                          context: context,
                          song: albumSongs[index],
                        );
                      },
                      songModel: albumSongs[index],
                      musicUri: albumSongs[index].musicUri,
                      songId: albumSongs[index].id,
                      pageType: PageTypeEnum.albumSongListPage,
                      albumName: albumSongs[index].musicAlbumName,
                      artistName: albumSongs[index].musicArtistName,
                      songTitle: albumSongs[index].musicName,
                      songFormat: albumSongs[index].musicFormat,
                      songPathIndevice: albumSongs[index].musicPathInDevice,
                      songSize: AppUsingCommonFunctions.convertToMBorKB(
                          albumSongs[index].musicFileSize),
                    );
                  },
                );
              }),
    );
  }
}
