import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;


import 'dashboardSingle.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'Silvio': 'password',
};


/// Class to implement the login screen. It's the home of the application
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  /// Establish a timeout parameter
  Duration get loginTime => const Duration(milliseconds: 2250);

  /// Given user data ([data.user] and [data.password] it returns an error
  /// message if the authentication fails (user or psw not found)
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      http.Response response =
          await BackendConnection.checkLogin(data.name, data.password);
      if (response.statusCode == 404) {
        return response.getField("message");
      }
      return null;
    });
  }

  /// Given a [data.name] and a [data.password] it register the new user
  /// TODO: implement the signup function
  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  /// Given a [name] = username it recover the password
  /// TODO: implement the recoverPassword method to send an email or something else
  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'Recover Password';
    });
  }

  /// Builds the home page for login.
  /// On success it readdress to the dashboard, else it gives errors of
  /// username or password not found.
  /// Default behaviour:
  /// * If you press signup it adds a field to confirm password
  /// * If you press "Forgot Password?" it address you to another screen
  /// where you have a user email field
  /// * on successful login you are addressed to DashboardScreen (all your plants)
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PlantVisor',
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