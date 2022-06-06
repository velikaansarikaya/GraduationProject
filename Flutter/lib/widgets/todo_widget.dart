// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todoapp/models/update_todo_request_model.dart';
import 'package:flutter_todoapp/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:flutter_todoapp/config.dart';
import 'package:flutter_todoapp/services/api_service.dart';
import 'update_todo_dialog_widget.dart';

class TodoWidget extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoWidget({
    required this.todo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          key: Key(todo['id']),
          actions: [
            IconSlideAction(
              color: Colors.green,
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => UpdateTodoDialogWidget(todo: todo),
                  barrierDismissible: false,
                ),
              caption: 'Edit',
              icon: Icons.edit,
            )
          ],
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              caption: 'Delete',
              onTap: () => deleteTodo(context, todo['_id']),
              icon: Icons.delete,
            )
          ],
          child: buildTodo(context),
        ),
      );

  Widget buildTodo(BuildContext context) => Container(
        color: Config.secondaryColor,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Checkbox(
              activeColor: Config.helperColor,
              checkColor: Colors.white,
              value: todo['iscompleted'],
              onChanged: (value) => {todo['iscompleted']=value,
               updateTodo(context, todo['_id'])},
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo['header'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),
                  if (todo['detail'].isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        todo['detail'],
                        style: TextStyle(fontSize: 20, height: 1.5),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );

  void deleteTodo(BuildContext context, String todoId) {
    APIService.deleteTodo(todoId).then(
      (response) {
        if (response.statusCode==200) {
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
        } else {
          FormHelper.showSimpleAlertDialog(
            context,
            Config.appName,
            response.body,
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

  void updateTodo(BuildContext context, String id) {
    UpdateTodoRequestModel model = UpdateTodoRequestModel(
        header: todo['header'], detail: todo['detail'], iscompleted: todo['iscompleted']);

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
}
