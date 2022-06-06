import 'package:snippet_coder_utils/hex_color.dart';

class Config {
  static const String appName = "Todo App";
  static const String apiURL = 'rattledoge-todorest.herokuapp.com'; 
  static const loginAPI = "/api/v1/auth/login";
  static const registerAPI = "/api/v1/auth/register";
  static const userProfileAPI = "/api/v1/auth/me";
  static const allTodosAPI = "/api/v1/todos";
  static const addTodoAPI = "/api/v1/todos/add";
  static const deleteTodoAPI ="/api/v1/todos/delete/";
  static const updateTodoAPI ="/api/v1/todos/update/";
  static const deleteCompletedTodosAPI = "/api/v1/todos/delete_completed";
  static var primaryColor = HexColor("#f54b33");
  static var secondaryColor = HexColor("#ff9c02");
  static var helperColor = HexColor("#92c647");
}
