import 'package:dartz/dartz.dart';

abstract class ArtistsRepository {
  Future<Either> getArtists();
  Future<Either> getSongsByArtist(String artist);
}