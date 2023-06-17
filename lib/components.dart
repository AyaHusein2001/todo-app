import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/states.dart';
import 'package:todo/todocubit.dart';

Widget buildtaskitem(Map model, BuildContext context) => Dismissible(
      //swipe right and left to delete
      key: Key(model['id'].toString()), //unique id for item must be strıng
      onDismissed: ((direction) {
        //ده اتجاه المسح
        // هنا أنا مش فارق معايا الاتجاه أنا كدا كدا هسحب سواء انت سحبت يمين و لا شمال
        todocubit.get(context).deletedata(model['id']);
      }),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: (() {
                  todocubit.get(context).updatedata('Done', model['id']);
                }),
                icon: Icon(Icons.check_box)),
            IconButton(
                onPressed: (() {
                  todocubit.get(context).updatedata('Archived', model['id']);
                }),
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                ))
          ],
        ),
      ),
    );
