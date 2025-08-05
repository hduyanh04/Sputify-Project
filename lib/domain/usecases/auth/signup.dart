import 'package:sputify/core/usecase/usecase.dart';
import 'package:sputify/data/models/auth/create_user_req.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/data/repository/auth/auth_repository_impl.dart';
import 'package:sputify/service_locator.dart';
import '../../repository/auth/auth.dart';

class SignupUseCase implements UseCase<Either,CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq ? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}