// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/models/add_todo_request_model.dart';
import 'package:flutter_todoapp/services/api_service.dart';
import 'package:flutter_todoapp/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:flutter_todoapp/config.dart';
import 'todo_form_widget.dart';

class AddTodoDialogWidget extends StatefulWidget {
  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  String header = '';
  String detail = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Form(
          key: globalFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TodoFormWidget(
                onChangedHeader: (header) =>
                    setState(() => this.header = header),
                onChangedDetail: (detail) =>
                    setState(() => this.detail = detail),
                onSavedTodo: addTodo,
              ),
            ],
          ),
        ),
      );

  void addTodo() {
    final isValid = globalFormKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      if (validateAndSave()) {
        setState(() {
          isApiCallProcess = true;
        });

        AddTodoRequestModel model =
            AddTodoRequestModel(header: header, detail: detail);

        APIService.addTodo(model).then(
          (response) {
            if (response.statusCode == 200) {
              FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                SharedService.displayMessage(response.body),
                "OK",
                () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              );
            } else if (response.statusCode == 401) {
              FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                SharedService.displayMessage(response.body),
                "OK",
                () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              );
            } else {
              FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                "An error occured.",
                "OK",
                () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              );
            }
          },
        );
      }
    }
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
