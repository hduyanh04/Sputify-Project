import 'package:dartz/dartz.dart';
import 'package:sputify/data/models/auth/create_user_req.dart';
import 'package:sputify/data/sources/auth/auth_firebase_service.dart';
import 'package:sputify/domain/repository/auth/auth.dart';
import 'package:sputify/service_locator.dart';
import '../../models/auth/signin_user_req.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }
}