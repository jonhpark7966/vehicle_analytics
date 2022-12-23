import 'package:data_handler/data_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';
import 'package:grid_ui_example/settings/theme.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);
  final AuthManage auth = AuthManage();

  Future<String?> _authUser(LoginData data) async {
    return await auth.signIn(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) async {
    return await auth.createUser(data.name??"", data.password??"");
  }


  Future<String?> _recoverPassword(String name) async {
    return await auth.sendPasswordResetEmail(name);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Automotive Statistics',
      //logo: AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pop();
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 0x1e, 0x02, 0x45),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Quicksand',
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}


