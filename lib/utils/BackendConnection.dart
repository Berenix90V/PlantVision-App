import 'dart:convert' as convert;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_plants_app/errors/exceptions.dart';
import 'package:smart_plants_app/models/Plant.dart';

/// Class to manage http requests to the backend
class BackendConnection {
  /// Given a [route] of type String, it returns the response of type Future<Response> (library: http/http.dart) to a get http request
  /// [route] is a partial url to connect to backend like "/user/login", the rest of the url is given by the env variable API_URL
  ///
  /// Throws [NotFoundException] if the requested resource doesn't exist.
  static Future<http.Response> _getRequest(String route,
      {Map<String, dynamic>? queryParameters}) async {
    Uri url = Uri.http(dotenv.get('API_URL'), route, queryParameters);
    return await http.get(url).catchError((error, stackTrace) => throw Future.error(
        NotFoundException(
            "The resource at $route with parameters ${queryParameters.toString()} does not exist"),
        stackTrace));
  }

  /// Handles a GET response, encapsulating exception handling. Returns a [http.Response]
  ///
  /// Throws [NotFoundException] when the route or the requested resource was not found
  static Future<http.Response> _handleGetExceptions(String route,
      {Map<String, dynamic>? queryParameters}) async {
    return await _getRequest(route, queryParameters: queryParameters)
        .catchError(
            (error, stackTrace) => throw Future.error(error, stackTrace));
  }

  /// Handles a POST response, encapsulating exception handling. Returns a [http.Response]
  ///
  /// Throws [NotFoundException] when the route was not found
  /// Throws [ConflictException] when there was a data conflict
  static Future<http.Response> _handlePostExceptions(
      String route, String body) async {
    return await _postRequest(route, body).catchError(
        (error, stackTrace) => throw Future.error(error, stackTrace));
  }

  /// Given a [route] of type String and a [body] of type String with json structure,it returns the response of type Future<Response> (library: http/http.dart) to a get http request
  /// [route] is a partial url to connect to backend like "/user/login", the rest is given by the env variable API_URL
  ///
  /// Throws [NotFoundException] when the route or the resource don't exist
  /// Throws [ConflictException] when the resource already exists
  static Future<http.Response> _postRequest(String route, String body) async {
    Uri url = Uri.http(dotenv.get('API_URL'), route);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return await http.post(url, body: body, headers: headers).catchError(
        (error, stackTrace) => throw Future.error(error, stackTrace));
  }

  /// Given a [username] and a [password] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a post request to the backend route "/user/login" to check if a given combination of username and password exists.
  /// To know the response refer to the API documentation.
  /// Throws [NotFoundException] when the route or resource are not found
  /// Throws [ConflictException] when the resource is conflicting with existing resources
  static Future<http.Response> checkLogin(
      String username, String password) async {
    String loginRoute = "/user/login";
    String body =
        convert.jsonEncode({'username': username, 'password': password});

    return await _handlePostExceptions(loginRoute, body);
  }

  ///Given a [username] and a [plantName] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a get request to the backend route "/sensor/[username]/[plantName]" to get the latest sensor reading
  /// To know the response refer to the backend API documentation.
  /// Throws [NotFoundException] when the user is not found, or the passwords don't match
  static Future<http.Response> latestReading(
      String username, String plantName) async {
    String readingRoute = "/sensor/$username/$plantName";
    return await _handleGetExceptions(readingRoute,
        queryParameters: {"latest": "true"});
  }

  /// Given a [username] returns a response of type [Future<Response>].
  ///
  /// It requests all plants from [username]
  /// To know the response refer to the backend API documentation.
  /// Throws [NotFoundException] when the plant is not found
  static Future<http.Response> getPlant(
      String username, String plantName) async {
    String plantRoute = "/plant/$username/$plantName";
    return await _handleGetExceptions(plantRoute);
  }

  /// Given a [username] and a [password] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a post request to the backend route "/plant/[username]" to create a new plant.
  /// To know the response refer to the API documentation.
  /// Throws [NotFoundException] when the route or resource are not found
  /// Throws [ConflictException] when the resource is conflicting with existing resources
  static Future<http.Response> createPlant(String username, Plant plant) async {
    String route = "/plant/$username";
    String body = convert.jsonEncode(plant.json);
    print(body);
    return await _handlePostExceptions(route, body);
  }
}

/// It extends the class Response from the library http/http.dart.
extension GetFields on http.Response {
  /// Fetches a particular [field] from the response body
  ///
  /// Throws [NotFoundException] when [field] is not present in the body
  dynamic getField(String field) {
    var jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
    if (jsonResponse.containsKey(field)) {
      return jsonResponse[field];
    } else {
      throw NotFoundException("Field $field doesn't exist");
    }
  }
}
