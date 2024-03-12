import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/appwrite/database_api.dart';
import 'package:todo/constants/color.dart';

import '../appwrite/auth_api.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/todo/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String? email, username = " ";
  late String? userId ="";
  late List<Document>? todos = [];
  final dataBase = DatabaseAPI();
  final AuthAPI auth = AuthAPI();
  late AuthStatus authStatus = AuthStatus.uninitialized;
  final TodoBloc todoBloc = TodoBloc(DatabaseAPI());
  TextEditingController newTaskController = TextEditingController();
  bool isTodoLoading = false;
  bool isTodoNotEmpty = true;

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {
      isTodoLoading = true;
    });
    //waiting for the userdata to load from the appwrite server and then loading the todos
    Future.delayed(const Duration(seconds: 3), () {
      todoBloc.add(TodoLoad(userId: userId));
      setState(() {
        isTodoLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBloc(AuthAPI());
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text(state.message),
            ),
          );
        }
        if ( state is AuthLogoutSuccess) {
          Navigator.pushNamed(context, '/login');
        }
      },
      builder: (context, state) {
        return BlocConsumer<TodoBloc, TodoState>(
          bloc: todoBloc,
          listener: (context, state) {
            if (state is TodoLoadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
            }
            if (state is TodoLoadSuccess) {
              setState(() {
                if(state.todos.isEmpty){
                  isTodoNotEmpty = false;
                }
                else{
                  isTodoNotEmpty = true;
                }
                todos = state.todos;
              });
            }
            if (state is TodoAddError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
            }
            if (state is TodoAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
              newTaskController.clear();
              todoBloc.add(TodoLoad(userId: userId));
            }
            if(state is TodoUpdateError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
            }
            if(state is TodoUpdateSuccess){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
              newTaskController.clear();
              todoBloc.add(TodoLoad(userId: userId));
            }
            if(state is TodoDeleteError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
            }
            if(state is TodoDeleteSuccess){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
              newTaskController.clear();
              todoBloc.add(TodoLoad(userId: userId));
            }
            if(state is TodoStatusChangedError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
            }
            if(state is TodoStatusChangedSuccess){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
              todoBloc.add(TodoLoad(userId: userId));
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: background,
              floatingActionButton: FloatingActionButton(
                heroTag: "field",
                backgroundColor: primary,
                onPressed: () {
                  if(newTaskController.text.isNotEmpty){
                    newTaskController.clear();
                  }
                  typeTask();
                  },
                child: const Icon(
                    size: 30,
                    color: background,
                    Icons.add
                ),
              ),
              body: SafeArea(
                child:Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'Galorine',
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                        child: Row(
                          children: [
                            Text(
                              "Hello, ${username?.replaceFirst(username?[0] as Pattern, username![0].toUpperCase())}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'WatchQuinn'
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                authBloc.add(AuthLogout());
                              },
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: primary,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      isTodoLoading ?
                          SizedBox(
                              height: MediaQuery.of(context).size.height*0.7,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                          )
                          :Container(
                            child: isTodoNotEmpty ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.05,
                                  vertical: MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: ListView.builder(
                                  itemCount: todos!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: taskTileBackground,
                                        border: Border.all(
                                          color: todos![index].data['complete'] ? primary : taskTileBorder,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context).size.width * 0.02,
                                          right: MediaQuery.of(context).size.width * 0.02,
                                          top: MediaQuery.of(context).size.height * 0.02,
                                          bottom: MediaQuery.of(context).size.height * 0.02,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.08,
                                                  height: MediaQuery.of(context).size.width * 0.08,
                                                  decoration: BoxDecoration(
                                                    color: background,
                                                    border: Border.all(
                                                      color: todos![index].data['complete'] ? taskTileBackground : primary,
                                                      width: 2,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                   todoBloc.add(TodoStatusChanged(id: todos![index].$id, isDone: !todos![index].data['complete']));
                                                  },
                                                  icon: Icon(
                                                    todos![index].data['complete'] ? Icons.circle : null,
                                                    color: todos![index].data['complete'] ? done : null,
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.01,
                                            ),
                                            Expanded(
                                              child: Text(
                                                todos![index].data['text'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  decoration: todos![index].data['complete'] ? TextDecoration.lineThrough : TextDecoration.none,
                                                  decorationColor: done,
                                                  decorationThickness: 1.8,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if(newTaskController.text.isEmpty){
                                                  newTaskController.text = todos![index].data['text'];
                                                }
                                                editTask(index);
                                              },
                                              child: const Icon(
                                                CupertinoIcons.pencil,
                                                color: primary,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.03,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                todoBloc.add(TodoDelete(id: todos![index].$id));
                                              },
                                              child: const Icon(
                                                CupertinoIcons.trash,
                                                color: error,
                                                size: 25,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.01,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    },
                                ),
                              ),
                            ) : const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: primary,
                                    size: 60,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Add a task to get started",
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 24,
                                      fontFamily: 'WatchQuinn',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );},
        );
      },
    );
  }

  loadData() async {
    final user = await auth.account.get();
    setState(() {
      username = user.name;
      email = user.email;
      userId = user.$id;
    });
  }

  typeTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Hero(
          tag: "field",
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            backgroundColor: background,
            title: const Text(
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontFamily: 'WatchQuinn',
                  fontWeight: FontWeight.w500,
                ),
                "Add a task"
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.15,
              child: Column(
                children: [
                  TextField(
                    controller: newTaskController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter your task",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary),
                    ),
                    onPressed: () {
                      if(newTaskController.text.isNotEmpty){
                        todoBloc.add(TodoAdd(message: newTaskController.text));
                        Navigator.pop(context);
                      }
                      else{
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Task cannot be empty"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        color: background,
                        fontSize: 18,
                        fontFamily: 'WatchQuinn',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  editTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: background,
          title: const Text(
              style: TextStyle(
                color: primary,
                fontSize: 24,
                fontFamily: 'WatchQuinn',
                fontWeight: FontWeight.w500,
              ),
              "Edit task"
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newTaskController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  decoration: const InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primary),
                  ),
                  onPressed: () {
                    if(newTaskController.text.isNotEmpty){
                      todoBloc.add(TodoUpdate(id: todos![index].$id, message: newTaskController.text, isDone: todos![index].data['complete']));
                      Navigator.pop(context);
                    }
                    else{
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Updated Task cannot be empty"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: background,
                      fontSize: 18,
                      fontFamily: 'WatchQuinn',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


// loadTodos() async {
//   try {
//     final value = await dataBase.getTodo(
//       userId : userId
//     );
//     setState(() {
//       if(value.documents.isEmpty){
//         isTodoNotEmpty = false;
//       }
//       else{
//         isTodoNotEmpty = true;
//       }
//       todos = value.documents.cast<Document>();
//     });
//   } catch (e) {
//     print(e);
//   }
// }
}
