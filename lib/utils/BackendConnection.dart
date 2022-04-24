import 'dart:convert' as convert;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_plants_app/errors/exceptions.dart';
import 'package:smart_plants_app/models/Plant.dart';

import '../models/Hub.dart';

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

  /// Given a [username] and a [hub] it returns a list of plants
  ///
  /// It submits a get request to the backend route "/hub/[username]/[hub]" to get the list of plants in the hub
  /// To know the response refer to the backend API documentation.
  /// Throws [NotFoundException] when the user is not found, or the hub don't match
  static Future<http.Response> getHubPlants(
      String username, String hub) async {
    String plantRoute = "/hub/$username/$hub";
    return await _handleGetExceptions(plantRoute);
  }

  ///Given a [username] and a [plantName] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a get request to the backend route "/sensor/[username]/[plantName]" to get the latest sensor reading
  /// To know the response refer to the backend API documentation.
  /// Throws [NotFoundException] when the user is not found, or the passwords don't match
  static Future<http.Response> latestReading(
      String username, String plantName, String hub) async {
    String readingRoute = "/sensor/$username/$hub/$plantName";
    return await _handleGetExceptions(readingRoute,
        queryParameters: {"latest": "true"});
  }

  /// Given a [username] returns a response of type [Future<Response>].
  ///
  /// To know the response refer to the backend API documentation.
  /// Throws [NotFoundException] when the plant is not found
  static Future<http.Response> getPlant(
      String username, String plantName, String hub) async {
    String plantRoute = "/hub/$username/$hub/$plantName";
    return await _handleGetExceptions(plantRoute);
  }

  /// Given a [username] and a [password] it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a post request to the backend route "/plant/[username]" to create a new plant.
  /// To know the response refer to the API documentation.
  /// Throws [NotFoundException] when the route or resource are not found
  /// Throws [ConflictException] when the resource is conflicting with existing resources
  static Future<http.Response> createPlant(String username, String hubname, Plant plant) async {
    String route = "/hub/$username/$hubname";
    String body = convert.jsonEncode(plant.json);
    print(body);
    return await _handlePostExceptions(route, body);
  }

  /// Returns user's plants divided per hub
  static Future<http.Response> getUserHubs(
      String username) async {
    String userPlantsRoute = "/hubs/$username";
    return await _handleGetExceptions(userPlantsRoute);
  }

  /// Given a [username]  it returns a response of type Future<Response> (library: http/http.dart).
  ///
  /// It submits a post request to the backend route "/user/[username]" to create a new hub.
  /// To know the response refer to the API documentation.
  /// Throws [NotFoundException] when the route or resource are not found
  /// Throws [ConflictException] when the resource is conflicting with existing resources
  static Future<http.Response> createHub(String username, Hub hub) async {
    String route = "/user/$username";
    String body = convert.jsonEncode(hub.json);
    print(body);
    return await _handlePostExceptions(route, body);
  }
}

/// It extends the class Response from the library http/http.dart.
extension GetFields on http.Response {
  /// Fetches a particular [field] from the response body
  ///
  /// Throws [NotFoundException] when [field] is not present in the body
  dynamic getField(String field, {bool required = true}) {
    var jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
    if (jsonResponse.containsKey(field)) {
      return jsonResponse[field];
    } else {
      if (required) {
        throw NotFoundException("Field $field doesn't exist");
      } else {
        return null;
      }
    }
  }
}
