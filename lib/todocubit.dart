import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/states.dart';
import 'package:todo/newtasks.dart';
import 'package:todo/archived.dart';
import 'package:todo/done.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class todocubit extends Cubit<AppStates> {
  late Database database;
  // String? hint;
  // Color? mycolor;
  int currentindex = 0;
  List<Widget> Screens = [
    newtasks(),
    Done(),
    Archived(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done',
    'Archived',
  ];
  bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit;
  List<Map> newtaskss = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  todocubit() : super(appinitstate());

  static todocubit get(context) => BlocProvider.of<todocubit>(context);
  void changeindex(int index) {
    currentindex = index;
    emit(appchangebotnavbar());
  }

  void createdatabase() {
    openDatabase('rntodo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) => print('Table Created'))
          .catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (database) {
      getdatafromdatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(appcreatedatabastate());
    });
  }

  void insertindatabase(
    @required String title,
    @required String date,
    @required String time,
    // @required String status,
  ) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERt Into tasks(title, date, time,status) VALUES("$title", "$date", "$time","New")')
          .then((value) {
        print('$value Inserted');
        emit(appinsertdatabastate());
        getdatafromdatabase(database);
      }).catchError((onError) {
        print(onError.toString());
      });
    });
  }

  void getdatafromdatabase(Database database) {
    newtaskss = [];
    donetasks = []; //بصفرهم عشان ميضيفش ع الموجود فيعيد كله تاني
    archivedtasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'New') {
            newtaskss.add(element);
          }
          if (element['status'] == 'Done') {
            donetasks.add(element);
          } else {
            archivedtasks.add(element);
          }
        },
      );
      emit(appgetdatabastate());
    });
  }

  void changebottomsheet(@required bool isshow, @required IconData icon) {
    isbottomsheetshown = isshow;
    fabicon = icon;
    emit(Appchangebutton());
  }

  void updatedata(@required String state, @required int id) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$state', id]).then((value) {
      emit(updatedatabasestate());
      getdatafromdatabase(database);
    });
  }

  void deletedata(@required int id) {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(deletedatabasestate());
      getdatafromdatabase(database);
    });
  }

  // void myvalidation(int x) {
  //   if (x == 1) hint = 'Title must not be empty';
  //   if (x == 2) hint = 'Date must not be empty';
  //   if (x == 2) hint = 'Time must not be empty';
  //   mycolor = Colors.red;
  //   emit(notitlestate());
  // }
}
