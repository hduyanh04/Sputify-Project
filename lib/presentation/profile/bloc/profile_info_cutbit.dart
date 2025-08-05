import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sputify/domain/usecases/auth/get_user.dart';
import 'package:sputify/presentation/profile/bloc/profile_info_state.dart';
import 'package:sputify/service_locator.dart';


class ProfileInfoCubit extends Cubit<ProfileInfoState> {

  ProfileInfoCubit() : super (ProfileInfoLoading());

  Future<void> getUser() async {

    var user = await sl<GetUserUseCase>().call();

    user.fold(
            (l){
          emit(
              ProfileInfoFailure()
          );
        },
            (userEntity) {
          emit(
              ProfileInfoLoaded(userEntity: userEntity)
          );
        }
    );
  }
}