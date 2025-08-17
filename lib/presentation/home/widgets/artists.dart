
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/common/helpers/is_dark_mode.dart';
import 'package:sputify/core/config/theme/app_colors.dart';
import 'package:sputify/domain/entities/artist/artist.dart';
import 'package:sputify/presentation/home/bloc/artists_cubit.dart';
import 'package:sputify/presentation/home/bloc/artists_state.dart';
import 'package:sputify/presentation/home/pages/artist_songs_page.dart';

class Artists extends StatelessWidget {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistsCubit()..getArtists(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<ArtistsCubit, ArtistsState>(
          builder: (context, state) {
            if (state is ArtistsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ArtistsLoaded) {
              return _artists(context, state.artists);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _artists(BuildContext context, List<ArtistEntity> artists) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: artists.length,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (context, index) {
        final artist = artists[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArtistSongsPage(artist: artist),
              ),
            );
          },
          child: SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(artist.photoUrl),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}