class UpdateTodoRequestModel {
  UpdateTodoRequestModel({
    required this.header,
    required this.detail,
    required this.iscompleted,
  });
  late final String header;
  late final String detail;
  late final bool iscompleted;
  
  UpdateTodoRequestModel.fromJson(Map<String, dynamic> json){
    header = json['header'];
    detail = json['detail'];
    iscompleted = json['iscompleted'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['header'] = header;
    _data['detail'] = detail;
    _data['iscompleted'] = iscompleted;
    return _data;
  }
}