import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.user,
  });
  late final User user;
  
  LoginResponseModel.fromJson(Map<String, dynamic> json){
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.access,
    required this.email,
    required this.refresh,
    required this.username,
  });
  late final String access;
  late final String email;
  late final String refresh;
  late final String username;
  
  User.fromJson(Map<String, dynamic> json){
    access = json['access'];
    email = json['email'];
    refresh = json['refresh'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['access'] = access;
    _data['email'] = email;
    _data['refresh'] = refresh;
    _data['username'] = username;
    return _data;
  }
}

class Data {
  Data({
    required this.username,
    required this.email,
    required this.date,
    required this.id,
    required this.token,
  });
  late final String username;
  late final String email;
  late final String date;
  late final String id;
  late final String token;

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    date = json['date'];
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['email'] = email;
    _data['date'] = date;
    _data['id'] = id;
    _data['token'] = token;
    return _data;
  }
}
