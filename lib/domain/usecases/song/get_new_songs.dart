import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/service_locator.dart';

class GetNewsSongsUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<SongsRepository>().getNewsSongs();
  }
}