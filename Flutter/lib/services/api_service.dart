
import 'dart:convert';
import 'package:flutter_todoapp/models/add_todo_request_model.dart';
import 'package:flutter_todoapp/models/login_request_model.dart';
import 'package:flutter_todoapp/models/login_response_model.dart';
import 'package:flutter_todoapp/models/register_request_model.dart';
import 'package:flutter_todoapp/models/register_response_model.dart';
import 'package:flutter_todoapp/models/update_todo_request_model.dart';
import 'package:flutter_todoapp/models/update_todo_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todoapp/config.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.loginAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );

      return true;
    } else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      return registerResponseJson(
      response.body,
    );
    } else {
      return registerResponseJson(
      response.body,
    );
    }
  }

  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}'
    };

    var url = Uri.http(Config.apiURL, Config.userProfileAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  static Future<String> getAllTodos() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}'
    };

    var url = Uri.http(Config.apiURL, Config.allTodosAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
      
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  static Future<http.Response> addTodo(
    AddTodoRequestModel model,
  ) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}'
    };

    var url = Uri.http(
      Config.apiURL,
      Config.addTodoAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return response;
    
  }

  static Future<http.Response> deleteTodo(String id) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}',
    };

    var url = Uri.http(Config.apiURL, Config.deleteTodoAPI+id);

    var response = await client.delete(
      url,
      headers: requestHeaders,
      
    );
    return response;
  }

static Future<http.Response> deleteComletedTodos() async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}',
    };

    var url = Uri.http(Config.apiURL, Config.deleteCompletedTodosAPI);

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );
    return response;
  }

static Future<UpdateTodoResponseModel> updateTodo(
    UpdateTodoRequestModel model, String id
  ) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.user.access}'
    };

    var url = Uri.http(
      Config.apiURL,
      Config.updateTodoAPI+id,
    );

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return updateTodoResponseJson(
      response.body,
    );
  }
}
