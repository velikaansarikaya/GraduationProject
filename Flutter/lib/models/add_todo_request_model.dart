class AddTodoRequestModel {
  AddTodoRequestModel({
    required this.header,
    required this.detail,
  });
  late final String header;
  late final String detail;
  
  AddTodoRequestModel.fromJson(Map<String, dynamic> json){
    header = json['header'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['header'] = header;
    _data['detail'] = detail;
    return _data;
  }
}