import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({Key? key}) : super(key: key);

  @override
  State<ScanHistory> createState() => ScanHistoryState();
}

class ScanHistoryState extends State<ScanHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<List<Scans>>(
              future: DatabaseHelper.instance.getScans(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Scans>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No scanned codes in List.'))
                    :ListView(
                  children: snapshot.data!.map((scans) {
                    return Center(
                      child: ListTile(
                        title: Text(scans.content),
                        trailing: ElevatedButton.icon(
                          onPressed: (){
                            setState(() {
                                DatabaseHelper.instance.remove(scans.id!);
                              });
                          },
                          icon: const Icon(Icons.delete_forever), 
                          label: const Text(""),
                        )
                      ),
                    );
                  }).toList(),
                );
              }),
      ),
    );
  }
}

class Scans {
  final int? id;
  final String content;

  Scans({this.id, required this.content});

  factory Scans.fromMap(Map<String, dynamic> json) => Scans(
        id: json['id'],
        content: json['content'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'scans.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scans(
          id INTEGER PRIMARY KEY,
          content TEXT
      )
      ''');
  }

  Future<List<Scans>> getScans() async {
    Database db = await instance.database;
    var scanContent = await db.query('scans', orderBy: 'id');
    List<Scans> scanList = scanContent.isNotEmpty
        ? scanContent.map((c) => Scans.fromMap(c)).toList()
        : [];
    return scanList;
  }

  Future<int> add(Scans scans) async {
    Database db = await instance.database;
    return await db.insert('scans', scans.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }
}
