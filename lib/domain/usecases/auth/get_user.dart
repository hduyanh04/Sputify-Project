import 'package:dartz/dartz.dart';
import 'package:sputify/core/usecase/usecase.dart';
import 'package:sputify/domain/repository/auth/auth.dart';
import 'package:sputify/service_locator.dart';

class GetUserUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }

}