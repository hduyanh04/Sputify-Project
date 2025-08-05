import 'package:dartz/dartz.dart' show Either;
import 'package:sputify/core/usecase/usecase.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/service_locator.dart';

class GetFavoriteSongsUseCase implements UseCase<Either,dynamic> {

  @override
  Future<Either> call({params}) async{
    return await sl<SongsRepository>().getUserFavoriteSongs();
  }
}