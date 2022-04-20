
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'Silvio': 'password',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {

       http.Response response = await BackendConnection.checkLogin(data.name, data.password);
      if(response.statusCode == 404){
        return response.getField("message");
      }
      /*
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }

       */
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'Recover Password';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SmartPlants',
      logo: const AssetImage('assets/images/plants_icon.png'),
      userType: LoginUserType.name,
      onLogin: _authUser,
      onSignup: _signupUser,
      userValidator: (data) => null,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}