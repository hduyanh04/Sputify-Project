import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sputify/common/helpers/is_dark_mode.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';
import 'package:sputify/common/widgets/button/basic_button_app.dart';
import 'package:sputify/core/config/assets/app_images.dart';
import 'package:sputify/core/config/assets/app_vectors.dart';
import 'package:sputify/presentation/auth/pages/signin.dart';
import 'package:sputify/presentation/auth/pages/signup.dart';

import '../../../core/config/theme/app_colors.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(AppImages.authBG),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppVectors.logo, width: 150),
                  const SizedBox(
                    height: 55,
                  ),
                  const Text('Enjoy listening to music',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const Text('Sputify is a cool audio streaming platform for everybody, everywhere',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(onPressed:
                        (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SignupPage())
                          );
                        }, title: 'Register'
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        flex: 1,
                        child: TextButton(onPressed:
                        (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SigninPage())
                        );},
                            child: Text('Sign in', style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: context.isDarkMode ? Colors.white : Colors.black
                            ),)
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        ]
      )
    );
  }
}
