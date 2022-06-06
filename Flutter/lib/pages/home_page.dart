// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/services/api_service.dart';
import 'package:flutter_todoapp/services/shared_service.dart';
import 'package:flutter_todoapp/widgets/todo_list_widget.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:flutter_todoapp/config.dart';
import 'package:flutter_todoapp/widgets/add_todo_dialog_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(completed: false),
      TodoListWidget(completed: true),
    ];

    return Scaffold(
      appBar: AppBar(
        title: userProfile(),
        backgroundColor: Config.secondaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              SharedService.logout(context);
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Config.secondaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
      ),
      backgroundColor: Config.primaryColor,
      body: tabs[selectedIndex],
      floatingActionButton: InkWell(
        splashColor: Colors.blue,
        onLongPress: () => deleteCompletedTodods(context),
        child: FloatingActionButton(
            heroTag: "btnleft",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Config.secondaryColor,
            onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddTodoDialogWidget(),
                  barrierDismissible: false,
                ),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Icon(
                  Icons.add,
                  size: 25,
                ),
                Text("/"),
                Icon(
                  Icons.delete_sharp,
                  size: 20,
                ),
              ],
            )),
      ),
    );
  }

  Widget userProfile() {
    return FutureBuilder(
      future: APIService.getUserProfile(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> model,
      ) {
        if (model.hasData) {
          if (model.data == "") {
            return Text('Sorry, Your session is expired.',
                style: TextStyle(color: Colors.black87));
          } else {
            var data = jsonDecode(model.data!);
            return Text('Welcome, ' + data["username"] + '!',
                style: TextStyle(color: Colors.black87));
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void deleteCompletedTodods(BuildContext context) {
    APIService.deleteComletedTodos().then(
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
        } else if (response.statusCode == 404) {
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
