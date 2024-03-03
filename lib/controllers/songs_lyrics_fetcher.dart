// Example using Dio package for HTTP requests
import 'package:dio/dio.dart';
import 'dart:developer';

const musixmatchApiKey = '4203a4a48d129aae76105f85ee848875';
final dio = Dio();

// Future<String> getLyrics(String trackId) async {
//   try {
//     final response = await dio.get(
//       'https://api.musixmatch.com/ws/1.1/track.lyrics.get',
//       queryParameters: {
//         'track_id': trackId,
//         'apikey': musixmatchApiKey,
//       },
//     );

//     final lyrics = response.data['message']['body']['lyrics']['lyrics_body'];
//     return lyrics.toString();
//   } catch (error) {
//     log('Error getting lyrics: $error');
//     return 'Lyrics not available';
//   }
// }
Future<String> getLyrics(String songName, String artistName) async {
  try {
    final response = await dio.get(
      'https://api.musixmatch.com/ws/1.1/track.search',
      queryParameters: {
        'q_track': songName,
        'q_artist': artistName,
        'apikey': musixmatchApiKey,
      },
    );

    final message = response.data['message'];

    if (message != null && message is Map && message.containsKey('body')) {
      final body = message['body'];

      if (body != null && body is Map && body.containsKey('track_list')) {
        final trackList = body['track_list'];

        if (trackList != null && trackList is List && trackList.isNotEmpty) {
          // Retrieve the track_id from the first result
          final trackId = trackList[0]['track']['track_id'].toString();

          // Use the retrieved track_id to get the lyrics
          final lyrics = await getLyricsByTrackId(trackId);
          return lyrics;
        }
      }
    }

    // If no track is found or any part of the expected structure is missing
    return 'Lyrics not available';
  } catch (error) {
    log('Error getting lyrics: $error');
    return 'Lyrics not available';
  }
}

// Function to get lyrics by track_id
Future<String> getLyricsByTrackId(String trackId) async {
  try {
    final response = await dio.get(
      'https://api.musixmatch.com/ws/1.1/track.lyrics.get',
      queryParameters: {
        'track_id': '6300',
        'apikey': musixmatchApiKey,
      },
    );

    final lyrics =
        response.data['message']['body']['lyrics']['lyrics_body'].toString();
    return lyrics;
  } catch (error) {
    log('Error getting lyrics: $error');
    return 'Lyrics not available';
  }
}





