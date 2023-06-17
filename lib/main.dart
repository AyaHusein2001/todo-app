import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:todo/bloc_observer.dart';
import 'package:todo/newtasks.dart';
import 'package:todo/archived.dart';
import 'package:todo/done.dart';
import 'package:todo/todocubit.dart';
import 'package:todo/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var skey = GlobalKey<ScaffoldState>();
  var fkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();

  @override

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => todocubit()..createdatabase(),
          child: BlocConsumer<todocubit, AppStates>(
            listener: ((context, state) {
              if (state is appinsertdatabastate) {
                Navigator.pop(context);
              }
            }),
            builder: (context, state) {
              var cubit = todocubit.get(context);
              return Scaffold(
                key: skey,
                body: cubit.Screens[cubit.currentindex],
                appBar: AppBar(
                  title: Text(cubit.titles[cubit.currentindex]),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isbottomsheetshown) {
                      if (skey.currentState != null &&
                          fkey.currentState != null &&
                          fkey.currentState!.validate()) {
                        cubit.insertindatabase(titlecontroller.text,
                            datecontroller.text, timecontroller.text);
                        cubit.changebottomsheet(false, Icons.edit);
                      }
                    } else {
                      skey.currentState!
                          .showBottomSheet((context) {
                            return Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(15.0),
                              child: Form(
                                key: fkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: titlecontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          print('Title must not be empty');
                                          // cubit.myvalidation(1);
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        // hintText: cubit.hint ?? '',
                                        // hintStyle: TextStyle(
                                        //     color:
                                        //         cubit.mycolor ?? Colors.black),
                                        label: Text('Title'),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.title),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.datetime,
                                      controller: datecontroller,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2030-11-10'))
                                            .then((value) {
                                          datecontroller.text =
                                              '${value!.day}-${value!.month}-${value!.year}';
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          print('Date must not be empty');
                                          // cubit.myvalidation(2);
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        // hintText: cubit.hint ?? '',
                                        // hintStyle: TextStyle(
                                        //     color:
                                        //         cubit.mycolor ?? Colors.black),
                                        label: Text('Date'),
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.datetime,
                                      controller: timecontroller,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timecontroller.text =
                                              value!.format(context);
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // cubit.myvalidation(3);
                                          print('Time must not be empty');
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        // hintText: cubit.hint ?? '',
                                        // hintStyle: TextStyle(
                                        //     color:
                                        //         cubit.mycolor ?? Colors.black),
                                        label: Text('Time'),
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          .closed
                          .then((value) {
                            cubit.changebottomsheet(false, Icons.edit);
                          });
                      cubit.changebottomsheet(true, Icons.add);
                    }
                    // setState(() {
                    //   fabicon = Icons.add;
                    // });
                  },
                  child: Icon(
                    cubit.fabicon,
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: cubit.currentindex,
                    onTap: (value) {
                      cubit.changeindex(value);
                    },
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.menu,
                          ),
                          label: 'Tasks'),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.check_circle_outline,
                          ),
                          label: 'Done'),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.archive_outlined,
                          ),
                          label: 'Archived'),
                    ]),
              );
            },
          ),
        ));
  }
}
