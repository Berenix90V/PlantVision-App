import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/// Class to manage http requests to the backend
class BackendConnection{

  /// Given a [route] of type String, it returns the response of type Future<Response> (library: http/http.dart) to a get http request
  /// [route] is a partial url to connect to backend like "/user/login", the rest of the url is given by the env variable API_URL
  static Future<http.Response> getRequest(String route) async {
    Uri url =  Uri.http(dotenv.get('API_URL'), route);
    return await http.get(url);
  }

  /// Given a [route] of type String and a [body] of type String with json structure,it returns the response of type Future<Response> (library: http/http.dart) to a get http request
  /// [route] is a partial url to connect to backend like "/user/login", the rest is given by the env variable API_URL
  static Future<http.Response> postRequest(String route, String body) async {
    Uri url =  Uri.http(dotenv.get('API_URL'), route);
    Map <String, String> headers= {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return await http.post(url, body: body, headers: headers);
  }
  /// Given a [username] and a [password] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a post request to the backend route "/user/login" to check if a given cmbination of username and password exists.
  /// To know the response refer to the API documentation.
  static Future<http.Response> checkLogin(String username, String password) async {
    String loginRoute = "/user/login";
    String body = convert.jsonEncode({'username': username, 'password': password});

    http.Response response = await postRequest(loginRoute, body);
    return response;
  }

}

/// It extends the class Response from the library http/http.dart. Given
extension GetFields on http.Response {
  dynamic getField(String field){
    var jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
    if(jsonResponse.containsKey(field)) {
      return jsonResponse[field];
    } else{
      throw RangeError("Field $field doesn't exist");
    }
  }
}