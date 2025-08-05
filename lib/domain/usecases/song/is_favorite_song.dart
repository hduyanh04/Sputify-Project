import 'package:sputify/core/usecase/usecase.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/service_locator.dart';

class IsFavoriteSongUseCase implements UseCase<bool,String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<SongsRepository>().isFavoriteSong(params!);
  }
}