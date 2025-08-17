import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/domain/repository/song/song.dart';
import 'package:sputify/service_locator.dart';

class SearchSongsUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return const Left('Query cannot be empty');
    }
    return sl<SongsRepository>().searchSongs(params);
  }
}