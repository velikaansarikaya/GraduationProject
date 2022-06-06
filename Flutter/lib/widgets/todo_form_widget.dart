// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_todoapp/config.dart';

class TodoFormWidget extends StatelessWidget {
  final String header;
  final String detail;
  final ValueChanged<String> onChangedHeader;
  final ValueChanged<String> onChangedDetail;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key? key,
    this.header = '',
    this.detail = '',
    required this.onChangedHeader,
    required this.onChangedDetail,
    required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildHeader(),
            SizedBox(height: 8),
            buildDetail(),
            SizedBox(height: 32),
            buildButton(),
          ],
        ),
      );

  Widget buildHeader() => TextFormField(
        maxLines: 1,
        initialValue: header,
        onChanged: onChangedHeader,
        validator: (header) {
          if (header!.isEmpty) {
            return 'The header cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Header',
        ),
      );

  Widget buildDetail() => TextFormField(
        maxLines: 3,
        initialValue: detail,
        onChanged: onChangedDetail,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Detail',
        ),
      );

  Widget buildButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Config.helperColor),
          ),
          onPressed: onSavedTodo,
          child: Text('Save'),
        ),
      );
}
