import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todonight/models/note.dart';

// Clase con funciones para crear la base de datos
// y leer, escribir, actualizar y eliminar datos.
class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  // Función que retorna la base de datos si es que existe alguna
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  // Encuentra la ruta para almacenar la base de datos
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crea la base de datos
  Future _createDB(Database db, int version) async {
    // Define los tipos de datos a guardar
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    // Ejecuta el comando SQL create table
    await db.execute('''
    CREATE TABLE $tableNotes ( 
      ${NoteFields.id} $idType, 
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.createdTime} $textType
    )''');
  }

  // Inserta una nota a la base de datos
  // obteniendola como parametro y creando un nuevo id
  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  // Lee una nota obteniendo su id
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('La nota $id no fue encontrada');
    }
  }

  // Lee todas las notas
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.createdTime} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  // Actualiza una nota
  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  // Elimina una nota
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Cierra la conexión con la base de datos
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
