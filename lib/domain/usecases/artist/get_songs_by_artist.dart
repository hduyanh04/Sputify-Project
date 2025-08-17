import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/domain/repository/artist/artist.dart';
import 'package:sputify/service_locator.dart';

class GetSongsByArtistUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    if (params == null) {
      throw ArgumentError('params cannot be null');
    }
    return sl<ArtistsRepository>().getSongsByArtist(params);
  }
}