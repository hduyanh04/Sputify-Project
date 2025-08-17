import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/domain/repository/artist/artist.dart';
import 'package:sputify/service_locator.dart';

class GetArtistsUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ArtistsRepository>().getArtists();
  }
}