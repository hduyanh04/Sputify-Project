import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sputify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;

  // NEW: Playlist and current index
  List<String> playlist = [];
  int currentIndex = 0;

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        songDuration = duration;
      }
    });

    // Auto play next song when current finishes
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  // Load single song (original function)
  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.setUrl(url);
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  // NEW: Load playlist
  Future<void> loadPlaylist(List<String> urls, {int startIndex = 0}) async {
    playlist = urls;
    currentIndex = startIndex;
    await loadSong(playlist[currentIndex]);
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause(); // Changed from stop() to pause()
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  // NEW: Play next song
  Future<void> playNext() async {
    if (playlist.isEmpty) return;

    currentIndex = (currentIndex + 1) % playlist.length; // loop around
    await loadSong(playlist[currentIndex]);
    audioPlayer.play();
  }

  // NEW: Play previous song
  Future<void> playPrevious() async {
    if (playlist.isEmpty) return;

    currentIndex =
        (currentIndex - 1 + playlist.length) % playlist.length; // loop around
    await loadSong(playlist[currentIndex]);
    audioPlayer.play();
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}