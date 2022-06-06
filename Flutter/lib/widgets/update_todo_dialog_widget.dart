// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_todoapp/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:flutter_todoapp/config.dart';
import 'package:flutter_todoapp/models/update_todo_request_model.dart';
import 'todo_form_widget.dart';

class UpdateTodoDialogWidget extends StatefulWidget {
  late final Map<String, dynamic> todo;
 UpdateTodoDialogWidget({
    required this.todo
  });
  

  @override
  _UpdateTodoDialogWidget createState() => _UpdateTodoDialogWidget(todo: todo);
}

class _UpdateTodoDialogWidget extends State<UpdateTodoDialogWidget> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late final Map<String, dynamic> todo;
  bool isApiCallProcess = false;
  String header = '';
  String detail = '';
 _UpdateTodoDialogWidget({
    required this.todo
  });
   

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Form(
          key: globalFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TodoFormWidget(
                header: todo['header'],
                detail: todo['detail'],
                onChangedHeader: (header) => setState(() =>  this.header= header),
                onChangedDetail:  (detail) =>
                    setState(() => this.detail = detail),
                onSavedTodo:()=> updateTodo(context,todo['_id']),
              ),
            ],
          ),
        ),
      );

  void updateTodo(BuildContext context, String id) {
    UpdateTodoRequestModel model = UpdateTodoRequestModel(
        header: header, detail: detail, iscompleted: todo['iscompleted']);

    APIService.updateTodo(model,id).then(
      (response) {
        if (response.id == id) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        } else {
          FormHelper.showSimpleAlertDialog(
            context,
            Config.appName,
            "Error. Your session is expired.",
            "OK",
            () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          );
        }
      },
    );
  }
  

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
