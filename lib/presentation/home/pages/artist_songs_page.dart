import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/domain/entities/artist/artist.dart';
import 'package:sputify/presentation/home/bloc/artist_songs_cubit.dart';
import 'package:sputify/presentation/home/bloc/artist_songs_state.dart';
import 'package:sputify/presentation/song_player/pages/song_player.dart';
import 'package:sputify/core/config/constants/app_urls.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';

class ArtistSongsPage extends StatelessWidget {
  final ArtistEntity artist;
  const ArtistSongsPage({required this.artist, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(artist.name),
      ),
      body: BlocProvider(
        create: (_) => ArtistSongsCubit()..getSongsByArtist(artist.name),
        child: BlocBuilder<ArtistSongsCubit, ArtistSongsState>(
          builder: (context, state) {
            if (state is ArtistSongsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ArtistSongsLoaded) {
              final songs = state.songs;
              if (songs.isEmpty) {
                return const Center(child: Text('No songs found'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: songs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final s = songs[index];
                  return ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${AppURLs.coverFirestorage}${s.artist} - ${s.title}.jpg?${AppURLs.mediaAlt}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(s.title),
                    subtitle: Text(s.artist),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongPlayerPage(
                            playlist: songs,
                            startIndex: index,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('Error loading songs'));
          },
        ),
      ),
    );
  }
}