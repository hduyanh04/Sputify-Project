import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sputify/data/models/song/song.dart';
import 'package:sputify/domain/entities/song/song.dart';
import 'package:sputify/domain/entities/artist/artist.dart';
import 'package:sputify/domain/usecases/song/is_favorite_song.dart';
import 'package:sputify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();

  // NEW:
  Future<Either> getArtists();
  Future<Either> getSongsByArtist(String artist);
  Future<Either> searchSongs(String query);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  // Helper: build artist photo URL based on storage path naming convention
  String _artistPhotoUrl(String artist) {
    final encoded = Uri.encodeComponent(artist);
    return 'https://firebasestorage.googleapis.com/v0/b/sputify01.firebasestorage.app/o/artistPhotos%2F$encoded.jpg?alt=media';
  }

  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(5)
          .get();

      for (var element in data.docs) {
        var songData = element.data();

        var songModel = SongModel(
          title: songData['title'] ?? 'Unknown Title',
          artist: songData['artist'] ?? 'Unknown Artist',
          duration: songData['duration'] ?? 0,
          releaseDate: songData['releaseDate'] ?? Timestamp.now(),
          lyrics: songData['lyrics'] ?? '',
          isFavorite: false,
          songId: element.reference.id,
        );

        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id,
        );
        songModel.isFavorite = isFavorite;

        songs.add(songModel.toEntity());
      }
      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, please try again!');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songData = element.data();

        var songModel = SongModel(
          title: songData['title'] ?? 'Unknown Title',
          artist: songData['artist'] ?? 'Unknown Artist',
          duration: songData['duration'] ?? 0,
          releaseDate: songData['releaseDate'] ?? Timestamp.now(),
          lyrics: songData['lyrics'] ?? '',
          isFavorite: false,
          songId: element.reference.id,
        );

        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id,
        );
        songModel.isFavorite = isFavorite;

        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, please try again!');
    }
  }

  @override
  Future<Either> getArtists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Songs').get();
      final Set<String> names = {};
      for (var doc in snapshot.docs) {
        final a = (doc.data()['artist'] as String?)?.trim() ?? '';
        if (a.isNotEmpty) names.add(a);
      }

      final artists = names.map((name) {
        return ArtistEntity(
          name: name,
          photoUrl: _artistPhotoUrl(name),
        );
      }).toList();

      return Right(artists);
    } catch (e) {
      return const Left('An error occurred while fetching artists');
    }
  }

  @override
  Future<Either> getSongsByArtist(String artist) async {
    try {
      List<SongEntity> songs = [];
      var query = await FirebaseFirestore.instance
          .collection('Songs')
          .where('artist', isEqualTo: artist)
          .get(); // ✅ removed orderBy

      for (var element in query.docs) {
        var songData = element.data();

        var songModel = SongModel(
          title: songData['title'] ?? 'Unknown Title',
          artist: songData['artist'] ?? 'Unknown Artist',
          duration: songData['duration'] ?? 0,
          releaseDate: songData['releaseDate'] ?? Timestamp.now(),
          lyrics: songData['lyrics'] ?? '',
          isFavorite: false,
          songId: element.reference.id,
        );

        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id,
        );
        songModel.isFavorite = isFavorite;

        songs.add(songModel.toEntity());
      }

      // ✅ OPTIONAL: sort in Dart (newest first)
      songs.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred while fetching songs by artist');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();
      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });
        isFavorite = true;
      }
      return Right(isFavorite);
    } catch (e) {
      return const Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();
      return favoriteSongs.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      List<SongEntity> favoriteSongs = [];
      String uId = user!.uid;
      QuerySnapshot favoritesSnapshot = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .get();

      for (var element in favoritesSnapshot.docs) {
        String songId = element['songId'];
        var songDoc =
        await firebaseFirestore.collection('Songs').doc(songId).get();
        var songData = songDoc.data();

        if (songData != null) {
          var songModel = SongModel(
            title: songData['title'] ?? 'Unknown Title',
            artist: songData['artist'] ?? 'Unknown Artist',
            duration: songData['duration'] ?? 0,
            releaseDate: songData['releaseDate'] ?? Timestamp.now(),
            lyrics: songData['lyrics'] ?? '',
            isFavorite: true,
            songId: songId,
          );

          favoriteSongs.add(songModel.toEntity());
        }
      }

      return Right(favoriteSongs);
    } catch (e) {
      print(e);
      return const Left('An error occurred');
    }
  }
  @override
  Future<Either> searchSongs(String query) async {
    try {
      print('Search query: $query'); // DEBUG
      List<SongEntity> songs = [];

      // Fetch all songs from Firestore
      var snapshot = await FirebaseFirestore.instance.collection('Songs').get();
      print('Total songs in collection: ${snapshot.docs.length}');

      for (var element in snapshot.docs) {
        var songData = element.data();

        String title = (songData['title'] as String?)?.trim() ?? '';
        String artist = (songData['artist'] as String?)?.trim() ?? '';

        // Skip if both are empty
        if (title.isEmpty && artist.isEmpty) continue;

        // Match query against title or artist (case-insensitive)
        if (title.toLowerCase().contains(query.toLowerCase()) ||
            artist.toLowerCase().contains(query.toLowerCase())) {
          var songModel = SongModel(
            title: title,
            artist: artist,
            duration: songData['duration'] ?? 0,
            releaseDate: songData['releaseDate'] ?? Timestamp.now(),
            lyrics: songData['lyrics'] ?? '',
            isFavorite: false,
            songId: element.reference.id,
          );

          // Check if favorite
          bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
            params: element.reference.id,
          );
          songModel.isFavorite = isFavorite;

          songs.add(songModel.toEntity());
          print('Matched song: ${songModel.title} by ${songModel.artist}'); // DEBUG
        }
      }

      print('Total matched songs: ${songs.length}'); // DEBUG
      return Right(songs);
    } catch (e) {
      print('Error searching songs: $e');
      return const Left('Error searching songs');
    }
  }
}