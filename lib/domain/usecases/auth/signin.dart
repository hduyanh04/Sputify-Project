import 'package:sputify/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:sputify/data/models/auth/signin_user_req.dart';
import 'package:sputify/service_locator.dart';
import '../../repository/auth/auth.dart';

class SigninUseCase implements UseCase<Either,SigninUserReq> {
  @override
  Future<Either> call({SigninUserReq ? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}