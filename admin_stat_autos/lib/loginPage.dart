

import 'package:data_handler/data_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import 'provider/results_provider.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;


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
    _resultsProvider = Provider.of<ResultsProvider>(context);

    return FlutterLogin(
      title: 'Automotive Statistics',
      //logo: AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        _resultsProvider.reloadAndGetLatest();
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}