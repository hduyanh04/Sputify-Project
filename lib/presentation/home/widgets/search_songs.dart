import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/core/config/constants/app_urls.dart';
import 'package:sputify/presentation/home/bloc/search_songs_cubit.dart';
import 'package:sputify/presentation/home/bloc/search_songs_state.dart';
import 'package:sputify/presentation/song_player/pages/song_player.dart';

class SearchSongs extends StatelessWidget {
  const SearchSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search song or artist',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              if (query.isNotEmpty) {
                context.read<SearchSongsCubit>().search(query);
              } else {
                context.read<SearchSongsCubit>().clearResults();
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchSongsCubit, SearchSongsState>(
            builder: (context, state) {
              if (state is SearchSongsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchSongsLoaded) {
                final songs = state.songs;
                if (songs.isEmpty) {
                  return const Center(child: Text('No results found'));
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: Image.network(
                        '${AppURLs.coverFirestorage}${song.artist} - ${song.title}.jpg?${AppURLs.mediaAlt}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
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
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: songs.length,
                );
              }
              if (state is SearchSongsError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Type to search'));
            },
          ),
        ),
      ],
    );
  }
}