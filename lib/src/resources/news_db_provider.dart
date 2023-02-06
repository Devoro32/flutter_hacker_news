import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; //directory on mobile devices
import 'dart:io'; //device path system
import 'package:path/path.dart';
import 'dart:async';
import 'package:hnews/src/models/item_model.dart';
import 'package:hnews/src/resources/repository.dart';

class NewsDbProvider implements Source, Cache {
  late final Database db;

  NewsDbProvider() {
    init();
  }
  //234
  void init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'item.db');
    db = await openDatabase(path, version: 1,
        //Oncreate will only work if the user is opening the database for the very first time
        onCreate: (Database newDb, int version) {
      //""" use for multi line strings

      newDb.execute("""
        CREATE TABLE Items(
          id INTEGER PRIMARY KEY,
          type TEXT,
          by TEXT,
          time INTEGER,
          text TEXT, 
          parent INTEGER,
          kids BLOB,
          dead INTEGER,
          deleted INTEGER,
          url TEXT, 
          score INTEGER,
          title TEXT,
          descendants INTEGER 

        )

      """);
    });
  }

  @override
  Future<List<int>> fetchTopIds() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => [1, 2, 3, 4, 5, 6],
    );
    // Just want this to return something, it has to reture a future list int
    //Will never trigger because will use the fetchTopIds from the newsapi
  }

//!can make this method Future, but them we will cannot return null  Future<ItemModel>
  @override
  fetchItem(int id) async {
    //237
    //maps is key value pair List <Maps<string,dynamic>>- columns are string, values are dynamics
    final maps = await db.query(
      "items",
      //columns:["title","by",time] - use this to pull in specific columns, null pull in everything
      columns: null,
      where: "id=?",
      whereArgs: [id],
    ); //end of query

    //at least one result is found
    if (maps.isNotEmpty) {
      // turn the return into an ITEMMODEL
      return ItemModel.fromDb(maps.first);
    }

    //do not have the item, hence return null
    return ItemModel.fromDb(maps.first);
  } // end of fetchItem method

  //240
  @override
  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, //288
    );
  } //end of addItem

} // end of class

final newsDbProvider = NewsDbProvider();
