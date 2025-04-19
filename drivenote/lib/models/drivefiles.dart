class DriveFile {
  final String id;
  final String name;
  final String mimeType;

  DriveFile({required this.id, required this.name, required this.mimeType});

  factory DriveFile.fromJson(Map<String, dynamic> json) {
    return DriveFile(
      id: json['id'],
      name: json['name'],
      mimeType: json['mimeType'],
    );
  }

  
   DriveFile copyWith({
    String? id,
    String? name,
    String? mimeType,
  }) {
    return DriveFile(
      id: id ?? this.id,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }
}
