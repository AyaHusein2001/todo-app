import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:todo/bloc_observer.dart';
import 'package:todo/components.dart';
import 'package:todo/todocubit.dart';
import 'package:todo/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class newtasks extends StatelessWidget {
  const newtasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container();
    return BlocConsumer<todocubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: todocubit.get(context).newtaskss.length > 0,
            builder: ((context) {
              return ListView.separated(
                  itemBuilder: ((context, index) => buildtaskitem(
                      todocubit.get(context).archivedtasks[index], context)),
                  separatorBuilder: ((context, index) => Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      )),
                  itemCount: todocubit.get(context).archivedtasks.length);
            }),
            fallback: ((context) {
              return Center(
                  child: Text(
                'No Tasks yet , Please insert',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ));
            }));
      },
    );
  }
}
