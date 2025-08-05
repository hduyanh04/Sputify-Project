import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';
import 'package:sputify/common/widgets/button/basic_button_app.dart';
import 'package:sputify/core/config/assets/app_vectors.dart';
import 'package:sputify/data/models/auth/signin_user_req.dart';
import 'package:sputify/domain/usecases/auth/signin.dart';
import 'package:sputify/presentation/auth/pages/signup.dart';
import 'package:sputify/service_locator.dart';
import 'package:sputify/presentation/home/pages/home.dart';





class SigninPage extends StatelessWidget {
  SigninPage({super.key});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signupText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVectors.logo, height: 30, width: 30),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 30
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(height: 50),
            _emailField(context),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            BasicAppButton(onPressed: () async {
              var result = await sl<SigninUseCase>().call(
                  params: SigninUserReq(
                      email: _email.text.toString(),
                      password: _password.text.toString()
                  )
              );
              result.fold(
                      (l){
                    var snackbar = SnackBar(content: Text(l));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                      (r){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
                            (route)=>false);
                  }
              );
            },
                title: 'Sign in')
          ],
        ),
      ),
    );
  }
  Widget _registerText(){
    return const Text(
      'Sign In',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
      ),
    );
  }

  Widget _emailField(BuildContext context){
    return TextField(
      controller: _email,
      decoration: InputDecoration(
          hintText: 'Enter your email'
      ).applyDefaults(
          Theme.of(context).inputDecorationTheme
      ),
    );
  }
  Widget _passwordField(BuildContext context){
    return TextField(
      controller: _password,
      decoration: InputDecoration(
          hintText: 'Enter your password'
      ).applyDefaults(
          Theme.of(context).inputDecorationTheme
      ),
    );
  }
  Widget _signupText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not a member?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
            ),
          ),
          TextButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> SignupPage())
          );},
              child: const Text('Register'))
        ],
      ),
    );
  }
}