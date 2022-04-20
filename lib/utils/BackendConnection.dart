import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BackendConnection{

  static Future<http.Response> getRequest(String route) async {
    Uri url =  Uri.http(dotenv.get('API_URL'), route);
    return await http.get(url);
  }
  static Future<http.Response> postRequest(String route, String body) async {
    Uri url =  Uri.http(dotenv.get('API_URL'), route);
    Map <String, String> headers= {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return await http.post(url, body: body, headers: headers);
  }

  static Future<http.Response> checkLogin(String username, String password) async {
    String loginRoute = "/user/login";
    String body = convert.jsonEncode({'username': username, 'password': password});

    http.Response response = await postRequest(loginRoute, body);
    return response;
  }

}

extension GetFields on http.Response {
  dynamic getField(String field){
    var jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
    if(jsonResponse.containsKey(field)) {
      return jsonResponse[field];
    } else{
      return ErrorDescription("Field $field doesn't exist");
    }
  }
}