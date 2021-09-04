// Nombre de la tabla
final String tableNotes = 'notes';

// Encabezados de la tabla
class NoteFields {
  static final List<String> values = [id, title, 
  description, createdTime];
  static final String id = 'id';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
}

class Note {
  // Define las variables para la clase
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  // Constructor - Le indica a la clase de donde va obtener las variables
  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  // Copy es para crear una copia de la clase
  // y así saber si tenemos los datos para leerlos o necesitamos escribirlos
  Note copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) => Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  // Lectura de datos JSON
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.createdTime] as String),
      );

  // Escritura de datos JSON
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.createdTime: createdTime.toIso8601String(),
      };
}