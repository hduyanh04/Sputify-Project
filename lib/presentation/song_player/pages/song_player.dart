import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';
import 'package:sputify/common/widgets/favorite_button/favorite_button.dart';
import 'package:sputify/core/config/constants/app_urls.dart';
import 'package:sputify/core/config/theme/app_colors.dart';
import 'package:sputify/domain/entities/song/song.dart';
import 'package:sputify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:sputify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongEntity> playlist;
  final int startIndex;

  const SongPlayerPage({
    required this.playlist,
    this.startIndex = 0,
    super.key,
  });

  @override
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  bool isLyricsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: BlocProvider(
        create: (_) {
          final cubit = SongPlayerCubit();

          final urls = widget.playlist
              .map((song) =>
          '${AppURLs.songFirestorage}${song.artist} - ${song.title}.mp3?${AppURLs.mediaAlt}')
              .toList();

          cubit.loadPlaylist(urls, startIndex: widget.startIndex);
          return cubit;
        },
        child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
          builder: (context, state) {
            if (state is SongPlayerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SongPlayerLoaded) {
              final cubit = context.read<SongPlayerCubit>();
              final currentSong = widget.playlist[cubit.currentIndex];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _songCover(currentSong, context),
                    const SizedBox(height: 20),
                    _songDetail(currentSong),
                    const SizedBox(height: 20),

                    // ===== Lyrics section with header and expand/collapse =====
                    if (currentSong.lyrics.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Song Lyrics",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentSong.lyrics,
                              style: const TextStyle(
                                  fontSize: 16, height: 1.4),
                              textAlign: TextAlign.center,
                              maxLines: isLyricsExpanded ? null : 3,
                              overflow: isLyricsExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLyricsExpanded = !isLyricsExpanded;
                                });
                              },
                              child: Text(
                                isLyricsExpanded
                                    ? 'Show less'
                                    : 'Show more',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text(
                        "No lyrics available",
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),

                    const SizedBox(height: 35),
                    _songPlayer(context),
                  ],
                ),
              );
            }

            return const Center(child: Text("Error loading song"));
          },
        ),
      ),
    );
  }

  Widget _songCover(SongEntity songEntity, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.coverFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppURLs.mediaAlt}',
          ),
        ),
      ),
    );
  }

  Widget _songDetail(SongEntity songEntity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 5),
            Text(
              songEntity.artist,
              style:
              const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ],
        ),
        FavoriteButton(songEntity: songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    final cubit = context.read<SongPlayerCubit>();

    return Column(
      children: [
        Slider(
          value: cubit.songPosition.inSeconds.toDouble(),
          min: 0.0,
          max: cubit.songDuration.inSeconds.toDouble(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDuration(cubit.songPosition)),
            Text(formatDuration(cubit.songDuration)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.skip_previous),
              onPressed: () => cubit.playPrevious(),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => cubit.playOrPauseSong(),
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Icon(
                  cubit.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.skip_next),
              onPressed: () => cubit.playNext(),
            ),
          ],
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}