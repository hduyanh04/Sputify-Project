import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/service_locator.dart';

class AddOrRemoveFavoriteSongUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<SongsRepository>().addOrRemoveFavoriteSongs(params!);
  }
}