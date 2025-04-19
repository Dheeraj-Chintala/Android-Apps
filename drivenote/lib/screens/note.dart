import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drivenote/models/drivefiles.dart';
import 'package:drivenote/stateManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';

class Note extends ConsumerStatefulWidget {
  final DriveFile? existingFile;
  const Note({super.key, this.existingFile});

  @override
  ConsumerState<Note> createState() => _NoteState();
}

class _NoteState extends ConsumerState<Note> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  bool isUploading = false;

  Future<void> uploadNote() async {
    setState(() => isUploading = true);

    final token = await const FlutterSecureStorage().read(key: 'accesstoken');

    final dio = Dio();

    try {
      if (widget.existingFile != null) {
        // ✅ Update existing note
        final metadata = {'name': titleController.text};

        final formData = FormData.fromMap({
          'metadata': MultipartFile.fromString(
            jsonEncode(metadata),
            contentType: MediaType('application', 'json'),
          ),
          'file': MultipartFile.fromString(
            contentController.text,
            contentType: MediaType('text', 'plain'),
          ),
        });

        final response = await dio.patch(
          'https://www.googleapis.com/upload/drive/v3/files/${widget.existingFile!.id}?uploadType=multipart',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/related',
            },
          ),
        );

        final updatedFile = DriveFile(
          id: response.data['id'],
          name: response.data['name'],
          mimeType: response.data['mimeType'],
        );

        // ✅ Update file in Riverpod
        ref
            .read(driveFilesProvider.notifier)
            .updateFileName(updatedFile.id, updatedFile.name);
      } else {
        // ✅ Create new note
        String? folderId = await const FlutterSecureStorage().read(
          key: 'folderId',
        );

        if (folderId == null) {
          folderId = await createDriveFolder();
        }

        final metadata = {
          'name': titleController.text,
          'mimeType': 'text/plain',
          'parents': [folderId],
        };

        final formData = FormData.fromMap({
          'metadata': MultipartFile.fromString(
            jsonEncode(metadata),
            contentType: MediaType('application', 'json'),
          ),
          'file': MultipartFile.fromString(
            contentController.text,
            contentType: MediaType('text', 'plain'),
          ),
        });

        final response = await dio.post(
          'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/related',
            },
          ),
        );

        final fileData = response.data;
        final newFile = DriveFile(
          id: fileData['id'],
          name: fileData['name'],
          mimeType: fileData['mimeType'],
        );

        // ✅ Add new file to Riverpod
        ref.read(driveFilesProvider.notifier).addFile(newFile);
      }

      Navigator.pop(context);
    } catch (e) {
      print("Upload failed: $e");
    }

    setState(() => isUploading = false);
  }

  Future<String?> createDriveFolder() async {
    final token = await const FlutterSecureStorage().read(key: 'accesstoken');
    final dio = Dio();

    try {
      final response = await dio.post(
        'https://www.googleapis.com/drive/v3/files',
        data: {
          'name': 'DriveNotes',
          'mimeType': 'application/vnd.google-apps.folder',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      final folderId = response.data['id'];
      await const FlutterSecureStorage().write(
        key: 'folderId',
        value: folderId,
      );
      return folderId;
    } catch (e) {
      print("Folder creation failed: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    noteExist();
  }

  noteExist() async {
    if (widget.existingFile != null) {
      final token = await FlutterSecureStorage().read(key: "accesstoken");
      titleController.text = widget.existingFile!.name;
      contentController.text = await getFileContent(
        widget.existingFile!.id,
        token!,
      );
    }
  }

  Future<String> getFileContent(String fileId, String accessToken) async {
    final dio = Dio();
    final response = await dio.get(
      'https://www.googleapis.com/drive/v3/files/$fileId',
      queryParameters: {'alt': 'media'},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return response.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          widget.existingFile == null
              ? Text("Create Note", style: GoogleFonts.ptSans())
              : Text("Edit Note", style: GoogleFonts.ptSans()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              fillColor: Color.fromARGB(0, 255, 193, 7),
              focusedBorder: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
              labelText: "Title",
            ),
          ),
          TextField(
            controller: contentController,
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              fillColor: Color.fromARGB(0, 255, 193, 7),

              focusedBorder: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
              labelText: "Content",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isUploading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: isUploading ? null : uploadNote,
          child:
              isUploading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text("Upload"),
        ),
      ],
    );
  }
}
