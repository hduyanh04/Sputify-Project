import 'package:get_it/get_it.dart';
import 'package:sputify/data/repository/artist/artist_repository_impl.dart';
import 'package:sputify/data/sources/auth/auth_firebase_service.dart';
import 'package:sputify/data/sources/song/song_firebase_service.dart';
import 'package:sputify/domain/repository/artist/artist.dart';
import 'package:sputify/domain/repository/auth/auth.dart';
import 'package:sputify/data/repository/auth/auth_repository_impl.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/data/repository/song/song_repository_impl.dart';
import 'package:sputify/domain/usecases/artist/get_artists.dart';
import 'package:sputify/domain/usecases/artist/get_songs_by_artist.dart';
import 'package:sputify/domain/usecases/auth/get_user.dart';
import 'package:sputify/domain/usecases/auth/signup.dart';
import 'package:sputify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:sputify/domain/usecases/song/get_favorite_songs.dart';
import 'package:sputify/domain/usecases/song/get_new_songs.dart';
import 'package:sputify/domain/usecases/song/get_play_list.dart';
import 'package:sputify/domain/usecases/song/is_favorite_song.dart';
import 'package:sputify/domain/usecases/song/search_songs.dart';
import 'domain/usecases/auth/signin.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<SongsRepository>(SongRepositoryImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ArtistsRepository>(ArtistsRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<GetNewsSongsUseCase>(GetNewsSongsUseCase());
  sl.registerSingleton<GetPlayListUseCase>(GetPlayListUseCase());
  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(AddOrRemoveFavoriteSongUseCase());
  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());
  sl.registerSingleton<GetFavoriteSongsUseCase>(GetFavoriteSongsUseCase());

  sl.registerSingleton<SearchSongsUseCase>(SearchSongsUseCase());

  sl.registerSingleton<GetArtistsUseCase>(GetArtistsUseCase());
  sl.registerSingleton<GetSongsByArtistUseCase>(GetSongsByArtistUseCase());
}