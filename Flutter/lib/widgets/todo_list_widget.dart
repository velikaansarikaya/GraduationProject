// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/widgets/todo_widget.dart';
import 'package:flutter_todoapp/services/api_service.dart';

class TodoListWidget extends StatelessWidget {
  final bool completed;

  TodoListWidget({required this.completed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIService.getAllTodos(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> model,
      ) {
        if (model.hasData) {
          if (model.data == "") {
            return Center(
              child: Text(
                'No todos.',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            var data = jsonDecode(model.data!);
            var todoList = data['todo_list'];
            if (data['todo_list'].toString() == '[]') {
              return Center(
                child: Text(
                  'No todos.',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  separatorBuilder: (context, index) => Container(height: 8),
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    if (!completed) {
                      if (!todoList[index]['iscompleted']) {
                        return TodoWidget(todo: todoList[index]);
                      }
                    } else {
                      if (todoList[index]['iscompleted']) {
                        return TodoWidget(todo: todoList[index]);
                      }
                    }
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  });
            }
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
