import 'dart:convert';

UpdateTodoResponseModel updateTodoResponseJson(String str) =>
    UpdateTodoResponseModel.fromJson(json.decode(str));

class UpdateTodoResponseModel {
  UpdateTodoResponseModel({
    required this.id,
    required this.message,
  });
  late final String id;
  late final String message;
  
  UpdateTodoResponseModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['message'] = message;
    return _data;
  }
}