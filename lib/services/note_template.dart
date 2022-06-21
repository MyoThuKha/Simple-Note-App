import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteTemplate {
  Future<Database> initDatabase() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'Notes.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    //7 Column  5
    db.execute('''
CREATE TABLE Notes(
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  title TEXT,
  context TEXT,
  color INTEGER DEFAULT 0xffffffff,
  favorite INTEGER DEFAULT 0,
  date TEXT NOT NULL,
  time TEXT NOT NULL
)
''');
  }

  Future<int> create(String title, String context, int colorValue, String date,
      String time) async {
    Database db = await NoteTemplate().initDatabase();
    return await db.insert('Notes', {
      'title': title,
      'context': context,
      'color': colorValue,
      'date': date,
      'time': time
    });
  }

  Future<int> update(int id, String title, String context, int colorValue,
      int fav, String date, String time) async {
    Database db = await NoteTemplate().initDatabase();
    return await db.update(
        'Notes',
        {
          'title': title,
          'context': context,
          'color': colorValue,
          'favorite': fav,
          'date': date,
          'time': time
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<int> delete(int argId) async {
    Database db = await NoteTemplate().initDatabase();
    return await db.delete('Notes', where: 'id = ?', whereArgs: [argId]);
  }

  Future<void> deleteAll() async {
    Database db = await NoteTemplate().initDatabase();
    await db.delete('Notes');
  }

  Future<List<Map>> readNote(String name, dynamic value, String order) async {
    Database db = await NoteTemplate().initDatabase();
    String orderBy = 'id $order';
    var list = await db.query('Notes',
        orderBy: orderBy, where: '$name = ?', whereArgs: [value]);
    return list
        .map((data) => {
              'id': data['id'] as int,
              'title': data['title'] as String?,
              'context': data['context'] as String?,
              'color': data['color'] as int,
              'favorite': data['favorite'] as int,
              'date': data['date'] as String,
              'time': data['time'] as String
            })
        .toList();
  }

  Future<List<Map>> readAllNote(String order) async {
    Database db = await NoteTemplate().initDatabase();
    String orderBy = 'id $order';
    var list = await db.query('Notes', orderBy: orderBy);
    return list
        .map((data) => {
              'id': data['id'] as int,
              'title': data['title'] as String?,
              'context': data['context'] as String?,
              'color': data['color'] as int,
              'favorite': data['favorite'] as int,
              'date': data['date'] as String,
              'time': data['time'] as String
            })
        .toList();
  }

  Future<void> close() async {
    Database db = await NoteTemplate().initDatabase();
    db.close();
  }
}
